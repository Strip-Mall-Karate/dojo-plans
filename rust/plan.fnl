;; rust, ported from its plan.sh.
;; rust 1.99.1, the latest release on 2026-10-26.
(fn v-wrap-with-cert-path [b a1]
  (var v-bin "")
  (set v-bin (.. b.prefix :/bin/ a1))
  (b:log (.. "Adding wrapper " v-bin " to " v-bin :.real))
  (if (b:exists (.. v-bin :.real))
      (b:move v-bin (b:join (.. v-bin :.real) (: v-bin :match "[^/]+$")))
      (b:move v-bin (.. v-bin :.real)))
  (b:write v-bin (.. "#!" (b:path_for :busybox-static) "/bin/sh
set -e
export SSL_CERT_FILE=\""
                     (b:path_for :cacerts) "/ssl/cert.pem\"\nexec " v-bin ".real $@
"))
  (b:chmod v-bin :755))

{:name :rust
 :origin :karate
 :version :1.99.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0 :MIT]
 :description "Rust is a systems programming language that runs blazingly fast, prevents segfaults, and guarantees thread safety."
 :upstream_url "https://www.rust-lang.org/"
 :source {:url "https://static.rust-lang.org/dist/rust-1.99.1-x86_64-unknown-linux-gnu.tar.gz"
          :sha256 :aded4e6c1d580415e7b594a3080d8e23e9cbe06f159f97e300aa6875211f71bf
          :dirname :rust-1.99.1-x86_64-unknown-linux-gnu}
 :deps [:karate/glibc
        :karate/gcc-libs
        :karate/zlib
        :karate/gcc
        :karate/cacerts
        :karate/busybox-static]
 :build_deps [:karate/patchelf :karate/findutils :karate/coreutils]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :download (fn [b]
             (var v-p "")
             (b.default.download b)
             (let [v--target-shasumss [:89703fc52323fad35169fcf649e56844b7dd62bf9dd9a4113bbcd96865690e36]
                   v--target-sourcess ["https://static.rust-lang.org/dist/rust-std-1.99.1-x86_64-unknown-linux-musl.tar.gz"]]
               (for [n 1 1]
                 (set v-p (. v--target-sourcess n))
                 (b:download v-p (. v--target-shasumss n)
                             (: (: v-p :gsub "/+$" "") :match "[^/]*$"))))
             (set v-p ""))
 :verify (fn [b]
           (b.default.verify b)
           (let [v--target-shasumss [:89703fc52323fad35169fcf649e56844b7dd62bf9dd9a4113bbcd96865690e36]
                 v--target-sourcess ["https://static.rust-lang.org/dist/rust-std-1.99.1-x86_64-unknown-linux-musl.tar.gz"]]
             (for [n 1 1]
               nil)))
 :unpack (fn [b]
           (b.default.unpack b)
           (let [v--target-sourcess ["https://static.rust-lang.org/dist/rust-std-1.99.1-x86_64-unknown-linux-musl.tar.gz"]]
             (for [n 1 1]
               (b:run [:tar
                       :xf
                       (.. b.cache "/"
                           (: (: (. v--target-sourcess n) :gsub "/+$" "")
                              :match "[^/]*$"))]
                      {:cwd (.. b.cache :/rust-1.99.1-x86_64-unknown-linux-gnu)}))))
 :build (fn [b]
          nil)
 :install (fn [b]
            (var v-dir "")
            (b:run [:./install.sh (.. :--prefix= b.prefix) :--disable-ldconfig])
            ;; Every program the archive ships, the tools under lib/rustlib (rust-lld and the
            ;; rest) and libexec included, runs with karate glibc's dynamic linker: those
            ;; patchelf can print an interpreter for.
            (each [_ dir (ipairs [:bin :libexec :lib/rustlib])]
              (each [_ f (ipairs (b:find (b:join b.prefix dir) "*"))]
                (when (= 0 (b:run [:patchelf :--print-interpreter f]
                                  {:check false}))
                  (b:run [:patchelf
                          :--interpreter
                          (.. (b:path_for :glibc) :/lib/ld-linux-x86-64.so.2)
                          :--set-rpath
                          (or (b:getenv :LD_RUN_PATH) "")
                          f]))))
            ;; Every shared library, versioned names included (libLLVM.so.23.1-...), but the link
            ;; scripts beside them (libLLVM-23-....so is text): patchelf reads only ELF files.
            (each [_ f (ipairs (b:find (b:join b.prefix :lib) :*.so*))]
              (when (= 0 (b:run [:patchelf :--print-rpath f] {:check false}))
                (b:run [:patchelf
                        :--set-rpath
                        (or (b:getenv :LD_RUN_PATH) "")
                        f])))
            ;; Each extra target's standard library, unpacked beside the source, installed into rustc's sysroot.
            (let [sysroot (b:capture [(.. b.prefix :/bin/rustc)
                                      :--print
                                      :sysroot])]
              (each [_ source (ipairs ["https://static.rust-lang.org/dist/rust-std-1.99.1-x86_64-unknown-linux-musl.tar.gz"])]
                (let [dir (pick-values 1
                                       (: (source:match "[^/]+$") :gsub
                                          "%.tar%.gz$" ""))]
                  (b:log (.. "Installing " dir " target for Rust"))
                  (b:run [:./install.sh (.. :--prefix= sysroot)]
                         {:cwd (b:join b.src dir)}))))
            (v-wrap-with-cert-path b :cargo))
 :strip (fn [b]
          nil)}
