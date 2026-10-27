;; libxrandr, ported from its plan.sh.
{:name :libxrandr
 :origin :karate
 :version :1.5.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "X Resize and Rotate library"
 :upstream_url "https://www.x.org/"
 :source {:url "https://www.x.org/releases/individual/lib/libXrandr-1.5.1.tar.bz2"
          :sha256 :1ff9e7fa0e4adea912b16a5f0cfa7c1d35b0dcda0e216831f7715c8a3abcf51a
          :dirname :libXrandr-1.5.1}
 :deps [:karate/glibc
        :karate/libxrender
        :karate/xlib
        :karate/libxcb
        :karate/libxau
        :karate/libxdmcp
        :karate/libxext]
 :build_deps [:karate/diffutils
              :karate/gcc
              :karate/make
              :karate/pkg-config
              :karate/util-macros
              :karate/renderproto
              :karate/xproto
              :karate/kbproto
              :karate/libpthread-stubs
              :karate/xextproto
              :karate/randrproto]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]
 :check (fn [b]
          (b:run [:make :check]))}
