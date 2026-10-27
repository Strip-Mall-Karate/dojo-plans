;; libxi, ported from its plan.sh.
{:name :libxi
 :origin :karate
 :version :1.7.9
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "X.Org Libraries: libXi"
 :upstream_url "https://www.x.org/"
 :source {:url "https://www.x.org/releases/individual/lib/libXi-1.7.9.tar.bz2"
          :sha256 :c2e6b8ff84f9448386c1b5510a5cf5a16d788f76db018194dacdc200180faf45
          :dirname :libXi-1.7.9}
 :deps [:karate/glibc
        :karate/xlib
        :karate/libxext
        :karate/libxcb
        :karate/libxau
        :karate/libxdmcp]
 :build_deps [:karate/gcc
              :karate/make
              :karate/pkg-config
              :karate/xproto
              :karate/xextproto
              :karate/kbproto
              :karate/inputproto
              :karate/libpthread-stubs
              :karate/libxfixes
              :karate/fixesproto]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]
 :check (fn [b]
          (b:run [:make :check]))}
