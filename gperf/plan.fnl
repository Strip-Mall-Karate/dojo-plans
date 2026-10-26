;; gperf, ported from its plan.sh.
{:name "gperf"
 :origin "karate"
 :version "3.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPLv3"]
 :description "GNU gperf is a perfect hash function generator."
 :upstream_url "https://www.gnu.org/software/gperf/"
 :source {:url "http://ftp.gnu.org/pub/gnu/gperf/gperf-3.1.tar.gz" :sha256 "588546b945bba4b70b6a3a616e80b4ab466e3f33024a352fc2198112cdbb3ae2"}
 :deps ["karate/glibc" "karate/gcc-libs" "karate/gcc"]
 :build_deps ["karate/make"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]}
