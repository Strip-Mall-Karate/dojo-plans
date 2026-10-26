;; icu52, ported from its plan.sh.
{:name "icu52"
 :origin "karate"
 :version "52.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Unicode-TOU"]
 :description "ICU is a mature, widely used set of C/C++ and Java libraries providing\nUnicode and Globalization support for software applications. ICU is widely\nportable and gives applications the same results on all platforms and\nbetween C/C++ and Java software."
 :source {:url "http://download.icu-project.org/files/icu4c/52.1/icu4c-52_1-src.tgz" :sha256 "2f4d5e68d4698e87759dbdc1a586d053d96935787f79961d192c477b029d8092" :dirname "icu/source"}
 :deps ["karate/glibc" "karate/gcc-libs"]
 :build_deps ["karate/gcc" "karate/make"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]}
