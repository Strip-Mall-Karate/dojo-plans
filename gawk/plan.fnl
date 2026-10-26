;; gawk, ported from its plan.sh.
;; gawk 5.4.1, the latest release on 2026-10-26.
{:name "gawk"
 :origin "karate"
 :version "5.4.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["gplv3+"]
 :description "The awk utility interprets a special-purpose programming language that makes it possible to handle simple data-reformatting jobs with just a few lines of code."
 :upstream_url "http://www.gnu.org/software/gawk/"
 :source {:url "https://ftp.gnu.org/gnu/gawk/gawk-5.4.1.tar.xz" :sha256 "07f6f7342b7febe4313fc2c2542ad93d64fe20ad8717200109f105a826f5fd37"}
 ;; gmp by name: mpfr.h includes gmp.h. Without gmp's headers gawk 5.4.1 builds without MPFR,
 ;; and that build mangles strings (a[k] == "" then a[k] = a[k] "v" gives "0v"; fixed after 5.4.1).
 :deps ["karate/glibc" "karate/gmp" "karate/mpfr"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/sed"]
 :bin_dirs ["bin"]
 :interpreters ["bin/awk" "bin/gawk"]
 :check (fn [b]
          (b:run ["make" "check"]))}
