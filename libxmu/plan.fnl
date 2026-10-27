;; libxmu, ported from its plan.sh.
{:name :libxmu
 :origin :karate
 :version :1.1.2
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "X11 miscellaneous utility library"
 :upstream_url "https://www.x.org/"
 :source {:url "https://www.x.org/releases/individual/lib/libXmu-1.1.2.tar.bz2"
          :sha256 :756edc7c383254eef8b4e1b733c3bf1dc061b523c9f9833ac7058378b8349d0b
          :dirname :libXmu-1.1.2}
 :deps [:karate/glibc
        :karate/libxt
        :karate/libxext
        :karate/xlib
        :karate/libxcb
        :karate/libxau
        :karate/libxdmcp
        :karate/libice
        :karate/libsm]
 :build_deps [:karate/gcc
              :karate/make
              :karate/pkg-config
              :karate/xextproto
              :karate/xproto
              :karate/kbproto
              :karate/libpthread-stubs]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]
 :check (fn [b]
          (b:run [:make :check]))}
