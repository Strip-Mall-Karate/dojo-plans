;; libarchive-musl, ported from its plan.sh.
;; libarchive-musl 3.8.10, the latest release on 2026-10-26.
;; Built from the libarchive plan, with its own changes.
{:name "libarchive-musl"
 :origin "karate"
 :version "3.8.10"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["BSD"]
 :description "Multi-format archive and compression library"
 :upstream_url "https://www.libarchive.org"
 :source {:url "https://github.com/libarchive/libarchive/releases/download/v3.8.10/libarchive-3.8.10.tar.xz" :sha256 "56cad765459d5ee25a3b761f90c47d99379d28297fbfb72d908880d6b875fb96" :dirname "libarchive-3.8.10"}
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
