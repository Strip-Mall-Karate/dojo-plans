;; libsodium-musl, ported from its plan.sh.
;; libsodium-musl 1.0.22, the latest release on 2026-10-26: 1.0.16's source no longer downloads.
;; Built from the libsodium plan, with its own changes.
{:name "libsodium-musl"
 :origin "karate"
 :version "1.0.22"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["libsodium"]
 :description "Sodium is a new, easy-to-use software library for encryption, decryption, signatures, password hashing and more. It is a portable, cross-compilable, installable, packageable fork of NaCl, with a compatible API, and an extended API to improve usability even further."
 :upstream_url "https://github.com/jedisct1/libsodium"
 :source {:url "https://download.libsodium.org/libsodium/releases/libsodium-1.0.22.tar.gz" :sha256 "adbdd8f16149e81ac6078a03aca6fc03b592b89ef7b5ed83841c086191be3349" :dirname "libsodium-1.0.22"}
 :deps ["karate/musl"]
 :build_deps ["karate/autoconf" "karate/automake" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/sed"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :prepare (fn [b]
          (b:env "CC" "musl-gcc")
          (b:log (.. "Setting CC=" (or (b:getenv "CC") "")))
          ;; karate gcc names glibc's dynamic linker on every link; a musl program needs musl's,
          ;; which LDFLAGS gives last, as the other musl plans do.
          (b:env "LDFLAGS" (.. (or (b:getenv "LDFLAGS") "") " -Wl,--dynamic-linker=" (b:path_for "musl") "/lib/ld-musl-x86_64.so.1")))
 :check (fn [b]
          (b:run ["make" "check"]))}
