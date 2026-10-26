;; libxrender, ported from its plan.sh.
{:name "libxrender"
 :origin "karate"
 :version "0.9.10"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "X Rendering Extension client library"
 :upstream_url "https://www.x.org/"
 :source {:url "https://www.x.org/releases/individual/lib/libXrender-0.9.10.tar.bz2" :sha256 "c06d5979f86e64cabbde57c223938db0b939dff49fdb5a793a1d3d0396650949" :dirname "libXrender-0.9.10"}
 :deps ["karate/glibc" "karate/xlib" "karate/libxcb" "karate/libxau" "karate/libxdmcp"]
 :build_deps ["karate/gcc" "karate/make" "karate/pkg-config" "karate/xproto" "karate/kbproto" "karate/libpthread-stubs" "karate/renderproto"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :check (fn [b]
          (b:run ["make" "check"]))}
