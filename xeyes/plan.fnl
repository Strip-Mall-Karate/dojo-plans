;; xeyes, ported from its plan.sh.
{:name :xeyes
 :origin :karate
 :version :1.1.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description :xeyes
 :upstream_url "https://www.x.org/"
 :source {:url "https://www.x.org/releases/individual/app/xeyes-1.1.1.tar.bz2"
          :sha256 :975e98680cd59e1f9439016386609546ed08c284d0f05a95276f96aca6e8a521}
 :deps [:karate/glibc
        :karate/xlib
        :karate/libxcb
        :karate/libxau
        :karate/libxdmcp
        :karate/libxt
        :karate/libice
        :karate/libsm
        :karate/libxext
        :karate/libxrender
        :karate/libxmu]
 :build_deps [:karate/gcc
              :karate/make
              :karate/pkg-config
              :karate/xproto
              :karate/kbproto
              :karate/libpthread-stubs
              :karate/xextproto
              :karate/renderproto]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :check (fn [b]
          (b:run [:make :check]))}
