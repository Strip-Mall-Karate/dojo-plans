;; sed, ported from its plan.sh.
{:name "sed"
 :origin "karate"
 :version "4.5"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["gplv3"]
 :description "sed (stream editor) is a non-interactive command-line text editor. sed is commonly used to filter text, i.e., it takes text input, performs some operation (or set of operations) on it, and outputs the modified text. sed is typically used for extracting part of a file using pattern matching or substituting multiple occurrences of a string within a file."
 :upstream_url "https://www.gnu.org/software/sed/"
 :source {:url "http://ftp.gnu.org/gnu/sed/sed-4.5.tar.xz" :sha256 "7aad73c8839c2bdadca9476f884d2953cdace9567ecd0d90f9959f229d146b40"}
 :deps ["karate/glibc" "karate/acl"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc"]
 :bin_dirs ["bin"]
 :prepare (fn [b]
          (b:run ["patch" "-p1" "-i" (.. b.plan_dir "/fix-test-getopt-posix-with-glibc-2.26.patch")])
          (let [text (b:read (b:join b.src "Makefile.in"))] (b:write (b:join b.src "Makefile.in") (pick-values 1 (string.gsub text "[^\n]+" (fn [l] (var line l) (set line (pick-values 1 (string.gsub line "testsuite.panic%-tests.sh" "" 1))) line))))))
 :check (fn [b]
          (b:run ["make" "check"]))}
