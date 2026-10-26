;; scrnsaverproto, ported from its plan.sh.
{:name "scrnsaverproto"
 :origin "karate"
 :version "1.2.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "X11 wire protocol and auxillary headers"
 :upstream_url "https://www.x.org/"
 :source {:url "https://www.x.org/releases/individual/proto/scrnsaverproto-1.2.2.tar.bz2" :sha256 "8bb70a8da164930cceaeb4c74180291660533ad3cc45377b30a795d1b85bcd65"}
 :build_deps ["karate/gcc" "karate/make" "karate/pkg-config" "karate/util-macros"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]}
