;; gawk, ported from its plan.sh.
{:name "gawk"
 :origin "karate"
 :version "4.2.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["gplv3+"]
 :description "The awk utility interprets a special-purpose programming language that makes it possible to handle simple data-reformatting jobs with just a few lines of code."
 :upstream_url "http://www.gnu.org/software/gawk/"
 :source {:url "http://ftp.gnu.org/gnu/gawk/gawk-4.2.1.tar.gz" :sha256 "2b23d51503b2df9a41aa6fddc6002ad7ebf2a386ac19dc1b6be0dd48b0acf6db"}
 :deps ["karate/glibc" "karate/mpfr"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/sed"]
 :bin_dirs ["bin"]
 :interpreters ["bin/awk" "bin/gawk"]
 :check (fn [b]
          (b:run ["make" "check"]))}
