;; fixesproto, ported from its plan.sh.
{:name "fixesproto"
 :origin "karate"
 :version "5.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "X.Org Protocol Headers: fixesproto"
 :upstream_url "https://www.x.org/"
 :source {:url "https://www.x.org/releases/individual/proto/fixesproto-5.0.tar.bz2" :sha256 "ba2f3f31246bdd3f2a0acf8bd3b09ba99cab965c7fb2c2c92b7dc72870e424ce"}
 :build_deps ["karate/gcc" "karate/make" "karate/pkg-config" "karate/util-macros"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]}
