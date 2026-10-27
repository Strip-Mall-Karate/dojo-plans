;; libxscrnsaver, ported from its plan.sh.
{:name :libxscrnsaver
 :origin :karate
 :version :1.2.2
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "X11 Screen Saver extension client library"
 :upstream_url "https://www.x.org/"
 :source {:url "https://www.x.org/releases/individual/lib/libXScrnSaver-1.2.2.tar.bz2"
          :sha256 :8ff1efa7341c7f34bcf9b17c89648d6325ddaae22e3904e091794e0b4426ce1d
          :dirname :libXScrnSaver-1.2.2}
 :deps [:karate/glibc
        :karate/libxau
        :karate/libxcb
        :karate/libxdmcp
        :karate/libxext
        :karate/xlib]
 :build_deps [:karate/diffutils
              :karate/gcc
              :karate/kbproto
              :karate/libpthread-stubs
              :karate/make
              :karate/pkg-config
              :karate/scrnsaverproto
              :karate/util-macros
              :karate/xextproto
              :karate/xproto]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]}
