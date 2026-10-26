;; xextproto, ported from its plan.sh.
{:name "xextproto"
 :origin "karate"
 :version "7.3.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "X11 wire protocol extensions"
 :upstream_url "https://www.x.org/"
 :source {:url "https://www.x.org/releases/individual/proto/xextproto-7.3.0.tar.bz2" :sha256 "f3f4b23ac8db9c3a9e0d8edb591713f3d70ef9c3b175970dd8823dfc92aa5bb0"}
 :build_deps ["karate/gcc" "karate/make" "karate/pkg-config" "karate/util-macros"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]}
