;; bison2, ported from its plan.sh.
{:name "bison2"
 :origin "karate"
 :version "2.7.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-3.0"]
 :description "A parser generator that converts an annotated context-free grammar into a parser"
 :upstream_url "https://www.gnu.org/software/bison/"
 :source {:url "http://ftp.gnu.org/gnu/bison/bison-2.7.1.tar.xz" :sha256 "b409adcbf245baadb68d2f66accf6fdca5e282cafec1b865f4b5e963ba8ea7fb" :filename "bison-2.7.1.tar.xz" :dirname "bison-2.7.1"}
 :deps ["karate/glibc" "karate/m4"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/perl"]
 :bin_dirs ["bin"]
 :check (fn [b]
          (b:run ["make" "check"]))}
