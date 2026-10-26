;; bison, ported from its plan.sh.
{:name "bison"
 :origin "karate"
 :version "3.0.5"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-3.0"]
 :description "Bison is a general-purpose parser generator that converts an annotated context-free grammar into a deterministic LR or generalized LR (GLR) parser employing LALR(1) parser tables."
 :upstream_url "https://www.gnu.org/software/bison/"
 :source {:url "http://ftp.gnu.org/gnu/bison/bison-3.0.5.tar.xz" :sha256 "075cef2e814642e30e10e8155e93022e4a91ca38a65aa1d5467d4e969f97f338"}
 :deps ["karate/glibc"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/m4" "karate/perl"]
 :bin_dirs ["bin"]}
