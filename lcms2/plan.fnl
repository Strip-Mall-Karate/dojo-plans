;; lcms2, ported from its plan.sh.
{:name "lcms2"
 :origin "karate"
 :version "2.8"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "Small-footprint color management engine, version 2"
 :upstream_url "http://www.littlecms.com"
 :source {:url "http://downloads.sourceforge.net/sourceforge/lcms/lcms2-2.8.tar.gz" :sha256 "66d02b229d2ea9474e62c2b6cd6720fde946155cd1d0d2bffdab829790a0fb22"}
 :deps ["karate/glibc" "karate/jbigkit" "karate/libjpeg-turbo" "karate/libtiff" "karate/xz" "karate/zlib"]
 :build_deps ["karate/gcc" "karate/make"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :check (fn [b]
          (b:run ["make" "check"]))}
