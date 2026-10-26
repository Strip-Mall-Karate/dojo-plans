;; inputproto, ported from its plan.sh.
{:name "inputproto"
 :origin "karate"
 :version "2.3.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "X11 input extension wire protocol"
 :upstream_url "https://www.x.org/"
 :source {:url "https://www.x.org/releases/individual/proto/inputproto-2.3.2.tar.bz2" :sha256 "893a6af55733262058a27b38eeb1edc733669f01d404e8581b167f03c03ef31d"}
 :build_deps ["karate/gcc" "karate/make" "karate/pkg-config" "karate/util-macros"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]}
