;; libepoxy, ported from its plan.sh.
{:name :libepoxy
 :origin :karate
 :version :1.4.3
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "Epoxy is a library for handling OpenGL function pointer management for you"
 :upstream_url "https://github.com/anholt/libepoxy"
 :source {:url "https://github.com/anholt/libepoxy/releases/download/1.4.3/libepoxy-1.4.3.tar.xz"
          :sha256 :0b808a06c9685a62fca34b680abb8bc7fb2fda074478e329b063c1f872b826f6}
 :deps [:karate/glibc
        :karate/libdrm
        :karate/libxau
        :karate/libxcb
        :karate/libxdamage
        :karate/libxdmcp
        :karate/libxext
        :karate/libxfixes
        :karate/mesa
        :karate/xlib]
 :build_deps [:karate/damageproto
              :karate/fixesproto
              :karate/gcc
              :karate/kbproto
              :karate/libpthread-stubs
              :karate/meson
              :karate/ninja
              :karate/pkg-config
              :karate/python
              :karate/xextproto
              :karate/xproto]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]
 :build (fn [b]
          (b:mkdir (b:join b.src :_build))
          (b:run [:meson (.. :--prefix= b.prefix) :--buildtype :release]
                 {:cwd :_build})
          (b:run [:ninja] {:cwd :_build}))
 :install (fn [b]
            (b:run [:ninja :install] {:cwd :_build}))}
