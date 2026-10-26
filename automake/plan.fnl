;; automake, ported from its plan.sh.
{:name "automake"
 :origin "karate"
 :version "1.16"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0"]
 :description "Automake is a tool for automatically generating Makefile.in files compliant with the GNU Coding Standards."
 :upstream_url "https://www.gnu.org/software/automake/"
 :source {:url "http://ftp.gnu.org/gnu/automake/automake-1.16.tar.xz" :sha256 "f98f2d97b11851cbe7c2d4b4eaef498ae9d17a3c2ef1401609b7b4ca66655b8a"}
 :deps ["karate/perl"]
 :build_deps ["karate/autoconf" "karate/bison" "karate/coreutils" "karate/diffutils" "karate/flex" "karate/gcc" "karate/make"]
 :bin_dirs ["bin"]}
