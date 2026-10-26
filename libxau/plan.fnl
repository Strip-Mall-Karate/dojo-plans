;; libxau, ported from its plan.sh.
{:name "libxau"
 :origin "karate"
 :version "1.0.8"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "X11 authorization library"
 :upstream_url "https://www.x.org/"
 :source {:url "https://www.x.org/releases/individual/lib/libXau-1.0.8.tar.bz2" :sha256 "fdd477320aeb5cdd67272838722d6b7d544887dfe7de46e1e7cc0c27c2bea4f2" :dirname "libXau-1.0.8"}
 :deps ["karate/glibc"]
 :build_deps ["karate/gcc" "karate/make" "karate/pkg-config" "karate/xproto"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :check (fn [b]
          (b:run ["make" "check"]))}
