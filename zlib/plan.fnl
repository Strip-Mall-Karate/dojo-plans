;; zlib, ported from its plan.sh.
{:name "zlib"
 :origin "karate"
 :version "1.2.11"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["zlib"]
 :description "Compression library implementing the deflate compression method found in gzip and PKZIP."
 :upstream_url "http://www.zlib.net/"
 :source {:url "http://zlib.net/zlib-1.2.11.tar.gz" :sha256 "c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1" :dirname "zlib-1.2.11"}
 :deps ["karate/glibc"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :prepare (fn [b]
          (var v-dynamic-linker "")
          (b.default.prepare b)
          (set v-dynamic-linker (.. (b:path_for "glibc") "/lib/ld-linux-x86-64.so.2"))
          (b:env "LDFLAGS" (.. (or (b:getenv "LDFLAGS") "") " -Wl,-rpath=" (or (b:getenv "LD_RUN_PATH") "") ",--enable-new-dtags"))
          (b:env "LDFLAGS" (.. (or (b:getenv "LDFLAGS") "") " -Wl,--dynamic-linker=" v-dynamic-linker))
          (b:log (.. "Updating LDFLAGS=" (or (b:getenv "LDFLAGS") ""))))}
