;; xz-musl, ported from its plan.sh.
;; Built from the xz plan, with its own changes.
{:name "xz-musl"
 :origin "karate"
 :version "5.2.4"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["gpl2+" "lgpl2+"]
 :description "XZ Utils is free general-purpose data compression software with a high compression ratio. XZ Utils were written for POSIX-like systems, but also work on some not-so-POSIX systems. XZ Utils are the successor to LZMA Utils."
 :upstream_url "http://tukaani.org/xz/"
 :source {:url "http://tukaani.org/xz/xz-5.2.4.tar.gz" :sha256 "b512f3b726d3b37b6dc4c8570e137b9311e7552e8ccbab4d39d47ce5f4177145" :dirname "xz-5.2.4"}
 :deps ["karate/musl"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/sed"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :prepare (fn [b]
          (var v-dynamic-linker "")
          (b:env "CC" "musl-gcc")
          (b:log (.. "Setting CC=" (or (b:getenv "CC") "")))
          (set v-dynamic-linker (.. (b:path_for "musl") "/lib/ld-musl-x86_64.so.1"))
          (b:env "LDFLAGS" (.. (or (b:getenv "LDFLAGS") "") " -Wl,--dynamic-linker=" v-dynamic-linker)))
 :check (fn [b]
          (b:run ["make" "check"]))}
