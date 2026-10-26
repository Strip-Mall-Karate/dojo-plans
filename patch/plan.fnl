;; patch, ported from its plan.sh.
{:name "patch"
 :origin "karate"
 :version "2.7.6"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["gplv3+"]
 :description "Patch takes a patch file containing a difference listing produced by the diff program and applies those differences to one or more original files, producing patched versions."
 :upstream_url "https://www.gnu.org/software/patch/"
 :source {:url "http://ftp.gnu.org/gnu/patch/patch-2.7.6.tar.xz" :sha256 "ac610bda97abe0d9f6b7c963255a11dcb196c25e337c61f94e4778d632f1d8fd"}
 :deps ["karate/glibc" "karate/attr"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/make" "karate/gcc" "karate/sed"]
 :bin_dirs ["bin"]
 :check (fn [b]
          (b:run ["make" "check"]))}
