;; grep, ported from its plan.sh.
;; grep 3.12, the latest release on 2026-10-26.
{:name "grep"
 :origin "karate"
 :version "3.12"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["gplv3+"]
 :description "Grep searches one or more input files for lines containing a match to a specified pattern. By default, Grep outputs the matching lines."
 :upstream_url "https://www.gnu.org/software/grep/"
 :source {:url "https://ftp.gnu.org/gnu/grep/grep-3.12.tar.xz" :sha256 "2649b27c0e90e632eadcd757be06c6e9a4f48d941de51e7c0f83ff76408a07b9"}
 :deps ["karate/glibc" "karate/pcre2"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/perl"]
 :bin_dirs ["bin"]
 :prepare (fn [b]
          (b:run ["patch" "-p1" "-i" (.. b.plan_dir "/fix-test-getopt-posix-with-glibc-2.26.patch")]))
 :check (fn [b]
          (b:run ["make" "check"]))}
