;; icu, ported from its plan.sh.
{:name "icu"
 :origin "karate"
 :version "57.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Unicode-TOU"]
 :description "ICU is a mature, widely used set of C/C++ and Java libraries providing\nUnicode and Globalization support for software applications. ICU is widely\nportable and gives applications the same results on all platforms and\nbetween C/C++ and Java software."
 :source {:url "http://download.icu-project.org/files/icu4c/57.1/icu4c-57_1-src.tgz" :sha256 "ff8c67cb65949b1e7808f2359f2b80f722697048e90e7cfc382ec1fe229e9581" :dirname "icu/source"}
 :deps ["karate/glibc" "karate/gcc-libs"]
 :build_deps ["karate/gcc" "karate/make"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]}
