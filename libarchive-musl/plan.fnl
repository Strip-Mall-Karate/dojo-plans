;; libarchive-musl, ported from its plan.sh.
;; Built from the libarchive plan, with its own changes.
{:name "libarchive-musl"
 :origin "karate"
 :version "3.3.3"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["BSD"]
 :description "Multi-format archive and compression library"
 :upstream_url "https://www.libarchive.org"
 :source {:url "http://www.libarchive.org/downloads/libarchive-3.3.3.tar.gz" :sha256 "ba7eb1781c9fbbae178c4c6bad1c6eb08edab9a1496c64833d1715d022b30e2e" :dirname "libarchive-3.3.3"}
 :deps ["karate/musl" "karate/openssl-musl" "karate/zlib-musl" "karate/bzip2-musl" "karate/xz-musl"]
 :build_deps ["karate/gcc" "karate/coreutils" "karate/make"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :prepare (fn [b]
          (var v-dynamic-linker "")
          (b:env "CC" "musl-gcc")
          (b:log (.. "Setting CC=" (or (b:getenv "CC") "")))
          (set v-dynamic-linker (.. (b:path_for "musl") "/lib/ld-musl-x86_64.so.1"))
          (b:env "LDFLAGS" (.. (or (b:getenv "LDFLAGS") "") " -Wl,--dynamic-linker=" v-dynamic-linker)))
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--without-xml2" "--without-lzo2"] {:env {"CFLAGS" (.. (or (b:getenv "CFLAGS") "") " -fPIC")}})
          (b:run ["make"]))
 :check (fn [b]
          (b:run ["make" "check"] {:check false}))}
