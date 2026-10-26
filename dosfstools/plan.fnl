;; dosfstools, ported from its plan.sh.
{:name "dosfstools"
 :origin "karate"
 :version "4.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :source {:url "https://github.com/dosfstools/dosfstools/releases/download/v4.1/dosfstools-4.1.tar.gz" :sha256 "dc49997fd9fcd6e550c1a0dd5f97863d6ded99d465c33633a2b8769f4d72a137"}
 :deps ["karate/glibc"]
 :build_deps ["karate/make" "karate/gcc"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]}
