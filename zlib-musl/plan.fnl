;; zlib-musl, ported from its plan.sh.
;; Built from the zlib plan, with its own changes.
{:name "zlib-musl"
 :origin "karate"
 :version "1.2.11"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["zlib"]
 :description "Compression library implementing the deflate compression method found in gzip and PKZIP."
 :upstream_url "http://www.zlib.net/"
 :source {:url "http://zlib.net/zlib-1.2.11.tar.gz" :sha256 "c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1" :dirname "zlib-1.2.11"}
 :deps ["karate/musl"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :prepare (fn [b]
          (b:env "CC" "musl-gcc")
          (b:log (.. "Setting CC=" (or (b:getenv "CC") ""))))}
