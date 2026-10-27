;; damageproto, ported from its plan.sh.
{:name :damageproto
 :origin :karate
 :version :1.2.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "X11 Damage C header files"
 :upstream_url "https://www.x.org/"
 :source {:url "https://www.x.org/releases/individual/proto/damageproto-1.2.1.tar.bz2"
          :sha256 :5c7c112e9b9ea8a9d5b019e5f17d481ae20f766cb7a4648360e7c1b46fc9fc5b}
 :build_deps [:karate/gcc :karate/make :karate/pkg-config :karate/util-macros]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]}
