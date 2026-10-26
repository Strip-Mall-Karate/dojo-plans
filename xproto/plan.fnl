;; xproto, ported from its plan.sh.
{:name "xproto"
 :origin "karate"
 :version "7.0.31"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "X11 wire protocol and auxillary headers"
 :upstream_url "https://www.x.org/"
 :source {:url "https://www.x.org/releases/individual/proto/xproto-7.0.31.tar.bz2" :sha256 "c6f9747da0bd3a95f86b17fb8dd5e717c8f3ab7f0ece3ba1b247899ec1ef7747"}
 :build_deps ["karate/gcc" "karate/make" "karate/pkg-config" "karate/util-macros"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]}
