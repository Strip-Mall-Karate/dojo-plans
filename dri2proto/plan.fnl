;; dri2proto, ported from its plan.sh.
{:name :dri2proto
 :origin :karate
 :version :2.8
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "DRI2 proto"
 :upstream_url "https://www.x.org/"
 :source {:url "https://www.x.org/releases/individual/proto/dri2proto-2.8.tar.gz"
          :sha256 :7e65b031eaa6ebe23c75583d4abd993ded7add8009b4200a4db7aa10728b0f61}
 :build_deps [:karate/make :karate/gcc :karate/pkg-config :karate/util-macros]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]}
