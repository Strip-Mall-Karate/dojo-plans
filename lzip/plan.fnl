;; lzip, ported from its plan.sh.
{:name "lzip"
 :origin "karate"
 :version "1.18"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0"]
 :description "A lossless data compressor with a user interface similar to the one of gzip or bzip2."
 :upstream_url "http://www.nongnu.org/lzip/lzip.html"
 :source {:url "http://download.savannah.gnu.org/releases/lzip/lzip-1.18.tar.gz" :sha256 "47f9882a104ab05532f467a7b8f4ddbb898fa2f1e8d9d468556d6c2d04db14dd"}
 :deps ["karate/glibc" "karate/gcc-libs"]
 :build_deps ["karate/gcc" "karate/make" "karate/diffutils"]
 :bin_dirs ["bin"]
 :check (fn [b]
          (b:run ["make" "check"]))}
