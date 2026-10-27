;; zlib, ported from its plan.sh.
;; zlib 1.3.2, the latest release on 2026-10-26.
{:name :zlib
 :origin :karate
 :version :1.3.2
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:zlib]
 :description "Compression library implementing the deflate compression method found in gzip and PKZIP."
 :upstream_url "http://www.zlib.net/"
 :source {:url "https://zlib.net/zlib-1.3.2.tar.xz"
          :sha256 :d7a0654783a4da529d1bb793b7ad9c3318020af77667bcae35f95d0e42a792f3
          :dirname :zlib-1.3.2}
 :deps [:karate/glibc]
 :build_deps [:karate/coreutils
              :karate/diffutils
              :karate/patch
              :karate/make
              :karate/gcc]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]
 :prepare (fn [b]
            (var v-dynamic-linker "")
            (b.default.prepare b)
            (set v-dynamic-linker
                 (.. (b:path_for :glibc) :/lib/ld-linux-x86-64.so.2))
            (b:env :LDFLAGS
                   (.. (or (b:getenv :LDFLAGS) "") " -Wl,-rpath="
                       (or (b:getenv :LD_RUN_PATH) "") ",--enable-new-dtags"))
            (b:env :LDFLAGS
                   (.. (or (b:getenv :LDFLAGS) "") " -Wl,--dynamic-linker="
                       v-dynamic-linker))
            (b:log (.. "Updating LDFLAGS=" (or (b:getenv :LDFLAGS) ""))))}
