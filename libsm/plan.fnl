;; libsm, ported from its plan.sh.
{:name "libsm"
 :origin "karate"
 :version "1.2.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "X11 Session Management library"
 :upstream_url "https://www.x.org/"
 :source {:url "https://www.x.org/releases/individual/lib/libSM-1.2.2.tar.bz2" :sha256 "0baca8c9f5d934450a70896c4ad38d06475521255ca63b717a6510fdb6e287bd" :dirname "libSM-1.2.2"}
 :deps ["karate/glibc" "karate/libice"]
 :build_deps ["karate/gcc" "karate/make" "karate/pkg-config" "karate/xproto" "karate/xtrans"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :check (fn [b]
          (b:run ["make" "check"]))}
