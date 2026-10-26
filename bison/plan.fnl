;; bison, ported from its plan.sh.
;; bison 3.8.2, the latest release on 2026-10-26.
{:name "bison"
 :origin "karate"
 :version "3.8.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-3.0"]
 :description "Bison is a general-purpose parser generator that converts an annotated context-free grammar into a deterministic LR or generalized LR (GLR) parser employing LALR(1) parser tables."
 :upstream_url "https://www.gnu.org/software/bison/"
 :source {:url "https://ftp.gnu.org/gnu/bison/bison-3.8.2.tar.xz" :sha256 "9bba0214ccf7f1079c5d59210045227bcf619519840ebfa80cd3849cff5a5bf2"}
 :deps ["karate/glibc"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/m4" "karate/perl"]
 :bin_dirs ["bin"]}
