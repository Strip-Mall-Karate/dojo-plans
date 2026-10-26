;; libressl-musl, ported from its plan.sh.
;; Built from the libressl plan, with its own changes.
{:name "libressl-musl"
 :origin "karate"
 :version "2.4.4"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["OpenSSL"]
 :description "Version of the TLS/crypto stack forked from OpenSSL"
 :upstream_url "http://www.libressl.org/"
 :source {:url "http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-2.4.4.tar.gz" :sha256 "6fcfaf6934733ea1dcb2f6a4d459d9600e2f488793e51c2daf49b70518eebfd1" :dirname "libressl-2.4.4"}
 :deps ["karate/musl"]
 :build_deps ["karate/diffutils" "karate/file" "karate/make" "karate/gcc"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :prepare (fn [b]
          (var v-dynamic-linker "")
          (b:env "CC" "musl-gcc")
          (b:log (.. "Setting CC=" (or (b:getenv "CC") "")))
          (set v-dynamic-linker (.. (b:path_for "musl") "/lib/ld-musl-x86_64.so.1"))
          (b:env "LDFLAGS" (.. (or (b:getenv "LDFLAGS") "") " -Wl,--dynamic-linker=" v-dynamic-linker)))
 :check (fn [b]
          (b:run ["make" "check"]))}
