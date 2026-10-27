;; recordproto, ported from its plan.sh.
{:name :recordproto
 :origin :karate
 :version :1.14.2
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "X.Org Protocol Headers: recordproto"
 :upstream_url "https://www.x.org/"
 :source {:url "https://www.x.org/releases/individual/proto/recordproto-1.14.2.tar.bz2"
          :sha256 :a777548d2e92aa259f1528de3c4a36d15e07a4650d0976573a8e2ff5437e7370}
 :build_deps [:karate/gcc :karate/make :karate/pkg-config :karate/util-macros]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]}
