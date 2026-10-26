;; grep, ported from its plan.sh.
{:name "grep"
 :origin "karate"
 :version "3.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["gplv3+"]
 :description "Grep searches one or more input files for lines containing a match to a specified pattern. By default, Grep outputs the matching lines."
 :upstream_url "https://www.gnu.org/software/grep/"
 :source {:url "http://ftp.gnu.org/gnu/grep/grep-3.1.tar.xz" :sha256 "db625c7ab3bb3ee757b3926a5cfa8d9e1c3991ad24707a83dde8a5ef2bf7a07e"}
 :deps ["karate/glibc" "karate/pcre"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/perl"]
 :bin_dirs ["bin"]
 :prepare (fn [b]
          (b:run ["patch" "-p1" "-i" (.. b.plan_dir "/fix-test-getopt-posix-with-glibc-2.26.patch")]))
 :check (fn [b]
          (b:run ["make" "check"]))}
