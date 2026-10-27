;; glproto, ported from its plan.sh.
{:name :glproto
 :origin :karate
 :version :1.4.17
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:SGI-B-2.0]
 :description "GL proto"
 :upstream_url "https://www.x.org/"
 :source {:url "https://www.x.org/releases/individual/proto/glproto-1.4.17.tar.gz"
          :sha256 :9d8130fec2b98bd032db7730fa092dd9dec39f3de34f4bb03ceb43b9903dbc96}
 :build_deps [:karate/gcc :karate/make :karate/pkg-config :karate/util-macros]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]}
