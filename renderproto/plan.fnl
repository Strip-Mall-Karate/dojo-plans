;; renderproto, ported from its plan.sh.
{:name "renderproto"
 :origin "karate"
 :version "0.11.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "X11 Render extension wire protocol"
 :upstream_url "https://www.x.org/"
 :source {:url "https://www.x.org/releases/individual/proto/renderproto-0.11.1.tar.bz2" :sha256 "06735a5b92b20759204e4751ecd6064a2ad8a6246bb65b3078b862a00def2537"}
 :build_deps ["karate/gcc" "karate/make" "karate/pkg-config" "karate/util-macros"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]}
