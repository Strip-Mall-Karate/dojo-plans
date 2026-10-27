;; rust-nightly, ported from its plan.sh.
;; The source project's plan took the newest nightly, its checksum read from the
;; same server, and the version from it. This is the nightly current on 10 April
;; 2019 (built 2019-04-08, published 2019-04-09), pinned by the hashes in that
;; day's channel manifest; the version follows the plan's rule.
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

{:name :rust-nightly
 :origin :karate
 :maintainer "Strip Mall Karate Company"
 :targets [:x86_64-linux]
 :license [:Apache-2.0 :MIT]
 :description "Rust is a systems programming language that runs blazingly fast, prevents segfaults, and guarantees thread safety."
 :upstream_url "https://www.rust-lang.org/"
 :version :1.35.0-2019-04-08
 :source {:url "https://static.rust-lang.org/dist/2019-04-09/rust-nightly-x86_64-unknown-linux-gnu.tar.gz"
          :sha256 :be5df4b3bc0b1d96225e313d551a4639bf3d9eae95419d33de348ae128d4ad63
          :dirname :rust-nightly-x86_64-unknown-linux-gnu}
 :deps [:karate/glibc
        :karate/gcc-libs
        :karate/zlib
        :karate/gcc
        :karate/cacerts
        :karate/busybox-static]
 :build_deps [:karate/patchelf :karate/findutils :karate/coreutils :karate/sed]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :download (fn [b]
             (b.default.download b)
             (b:download "https://static.rust-lang.org/dist/2019-04-09/rust-std-nightly-x86_64-unknown-linux-musl.tar.gz"
                         :e6e0a90b3e3cbe2ade19eed5e209dcbee2b223dc85f119095d5d27513572e758
                         :rust-std-nightly-x86_64-unknown-linux-musl.tar.gz))
 :unpack (fn [b]
           (b.default.unpack b)
           (b:run [:tar
                   :xf
                   (b:join b.cache
                           :rust-std-nightly-x86_64-unknown-linux-musl.tar.gz)]
                  {:cwd b.src}))
 :build (fn [b]
          nil)
 :install (fn [b]
            (var v-dir "")
            (b:run [:./install.sh (.. :--prefix= b.prefix) :--disable-ldconfig])
            (each [_ v-b (ipairs [:rustc :cargo :rustdoc])]
              (b:run [:patchelf
                      :--interpreter
                      (.. (b:path_for :glibc) :/lib/ld-linux-x86-64.so.2)
                      :--set-rpath
                      (or (b:getenv :LD_RUN_PATH) "")
                      (.. b.prefix :/bin/ v-b)]))
            (each [_ f (ipairs (b:find (b:join b.prefix :lib) :*.so))]
              (b:run [:patchelf :--set-rpath (or (b:getenv :LD_RUN_PATH) "") f]))
            ;; Each extra target's standard library, unpacked beside the source, installed into rustc's sysroot.
            (let [sysroot (b:capture [(.. b.prefix :/bin/rustc)
                                      :--print
                                      :sysroot])]
              (each [_ source (ipairs ["https://static.rust-lang.org/dist/2019-04-09/rust-std-nightly-x86_64-unknown-linux-musl.tar.gz"])]
                (let [dir (pick-values 1
                                       (: (source:match "[^/]+$") :gsub
                                          "%.tar%.gz$" ""))]
                  (b:log (.. "Installing " dir " target for Rust"))
                  (b:run [:./install.sh (.. :--prefix= sysroot)]
                         {:cwd (b:join b.src dir)}))))
            (v-wrap-with-cert-path b :cargo))
 :strip (fn [b]
          nil)}
