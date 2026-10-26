;; libxcursor, ported from its plan.sh.
{:name "libxcursor"
 :origin "karate"
 :version "1.1.15"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "X11 miscellaneous extensions library"
 :upstream_url "https://www.x.org/"
 :source {:url "https://www.x.org/releases/individual/lib/libXcursor-1.1.15.tar.bz2" :sha256 "294e670dd37cd23995e69aae626629d4a2dfe5708851bbc13d032401b7a3df6b" :dirname "libXcursor-1.1.15"}
 :deps ["karate/glibc" "karate/libxau" "karate/libxcb" "karate/libxdmcp" "karate/libxfixes" "karate/libxrender" "karate/xlib"]
 :build_deps ["karate/fixesproto" "karate/gcc" "karate/kbproto" "karate/libpthread-stubs" "karate/make" "karate/pkg-config" "karate/renderproto" "karate/util-macros" "karate/xextproto" "karate/xproto"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]}
