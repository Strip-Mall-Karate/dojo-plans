;; libpthread-stubs, ported from its plan.sh.
{:name :libpthread-stubs
 :origin :karate
 :version :0.4
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "Weak aliases for pthread functions"
 :upstream_url "https://www.x.org/"
 :source {:url "https://www.x.org/releases/individual/xcb/libpthread-stubs-0.4.tar.bz2"
          :sha256 :e4d05911a3165d3b18321cc067fdd2f023f06436e391c6a28dff618a78d2e733}
 :build_deps [:karate/gcc :karate/make :karate/pkg-config :karate/diffutils]
 :lib_dirs [:lib]
 :pconfig_dirs [:lib/pkgconfig]
 :check (fn [b]
          (b:run [:make :check]))}
