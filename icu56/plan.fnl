;; icu56, ported from its plan.sh.
{:name "icu56"
 :origin "karate"
 :version "56.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Unicode-TOU"]
 :description "ICU is a mature, widely used set of C/C++ and Java libraries providing\nUnicode and Globalization support for software applications. ICU is widely\nportable and gives applications the same results on all platforms and\nbetween C/C++ and Java software."
 :upstream_url "http://site.icu-project.org/"
 :source {:url "http://download.icu-project.org/files/icu4c/56.1/icu4c-56_1-src.tgz" :sha256 "3a64e9105c734dcf631c0b3ed60404531bce6c0f5a64bfe1a6402a4cc2314816" :dirname "icu/source"}
 :deps ["karate/glibc" "karate/gcc-libs"]
 :build_deps ["karate/gcc" "karate/make"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]}
