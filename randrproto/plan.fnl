;; randrproto, ported from its plan.sh.
{:name "randrproto"
 :origin "karate"
 :version "1.5.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "X11 RandR extension wire protocol"
 :upstream_url "https://www.x.org/"
 :source {:url "https://www.x.org/releases/individual/proto/randrproto-1.5.0.tar.bz2" :sha256 "4c675533e79cd730997d232c8894b6692174dce58d3e207021b8f860be498468"}
 :build_deps ["karate/gcc" "karate/make" "karate/pkg-config" "karate/util-macros"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]}
