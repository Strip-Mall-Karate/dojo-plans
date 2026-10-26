;; kbproto, ported from its plan.sh.
{:name "kbproto"
 :origin "karate"
 :version "1.0.7"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "X11 XKB extension wire protocol"
 :upstream_url "https://www.x.org/"
 :source {:url "https://www.x.org/releases/individual/proto/kbproto-1.0.7.tar.bz2" :sha256 "f882210b76376e3fa006b11dbd890e56ec0942bc56e65d1249ff4af86f90b857"}
 :build_deps ["karate/gcc" "karate/make" "karate/pkg-config" "karate/util-macros"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]}
