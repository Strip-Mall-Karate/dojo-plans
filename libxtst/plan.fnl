;; libxtst, ported from its plan.sh.
{:name :libxtst
 :origin :karate
 :version :1.2.3
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "X.Org Libraries: libXtst"
 :upstream_url "https://www.x.org/"
 :source {:url "https://www.x.org/releases/individual/lib/libXtst-1.2.3.tar.bz2"
          :sha256 :4655498a1b8e844e3d6f21f3b2c4e2b571effb5fd83199d428a6ba7ea4bf5204
          :dirname :libXtst-1.2.3}
 :deps [:karate/glibc
        :karate/xlib
        :karate/libxcb
        :karate/libxau
        :karate/libxdmcp
        :karate/libxext
        :karate/libxi]
 :build_deps [:karate/gcc
              :karate/make
              :karate/pkg-config
              :karate/xproto
              :karate/kbproto
              :karate/renderproto
              :karate/inputproto
              :karate/xextproto
              :karate/libpthread-stubs
              :karate/libxfixes
              :karate/fixesproto
              :karate/recordproto]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]
 :check (fn [b]
          (b:run [:make :check]))}
