;; cargo-nightly, ported from its plan.sh.
;; The source project's plan took the newest cargo-dist build, its checksum read
;; from the same server, and the version from it. This is the cargo of the Rust
;; nightly current on 10 April 2019 (published 2019-04-09), pinned by the hash in
;; that day's channel manifest; the version follows the plan's rule.
(fn v-wrap-with-cert-path [b a1]
  (var v-bin "")
  (set v-bin (.. b.prefix :/bin/ a1))
  (b:log (.. "Adding wrapper " v-bin " to " v-bin :.real))
  (b:move v-bin (.. v-bin :.real))
  (b:write v-bin
           (.. "set -e\nexport SSL_CERT_FILE=\"" (b:path_for :cacerts) "/ssl/cert.pem\"
exec "
               v-bin ".real $@\n"))
  (b:chmod v-bin :755))

{:name :cargo-nightly
 :origin :karate
 :version :0.36.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0 :MIT]
 :description "The Rust package manager"
 :upstream_url "https://github.com/rust-lang/cargo"
 :source {:url "https://static.rust-lang.org/dist/2019-04-09/cargo-nightly-x86_64-unknown-linux-gnu.tar.gz"
          :sha256 :37daa4d0bf65469d25b80d25dd226717d8fc59dd1ee9c2b55cded82ced9371fc
          :dirname :cargo-nightly-x86_64-unknown-linux-gnu}
 :deps [:karate/glibc
        :karate/gcc-libs
        :karate/zlib
        :karate/gcc
        :karate/cacerts
        :karate/busybox-static]
 :build_deps [:karate/patchelf :karate/coreutils]
 :bin_dirs [:bin]
 :build (fn [b]
          nil)
 :install (fn [b]
            (b:run [:./install.sh (.. :--prefix= b.prefix) :--disable-ldconfig])
            (b:run [:patchelf
                    :--interpreter
                    (.. (b:path_for :glibc) :/lib/ld-linux-x86-64.so.2)
                    :--set-rpath
                    (or (b:getenv :LD_RUN_PATH) "")
                    (.. b.prefix :/bin/cargo)])
            (v-wrap-with-cert-path b :cargo))
 :strip (fn [b]
          nil)}
