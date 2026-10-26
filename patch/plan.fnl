;; patch, ported from its plan.sh.
;; patch 2.8.1, the latest release on 2026-10-26.
{:name "patch"
 :origin "karate"
 :version "2.8.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["gplv3+"]
 :description "Patch takes a patch file containing a difference listing produced by the diff program and applies those differences to one or more original files, producing patched versions."
 :upstream_url "https://www.gnu.org/software/patch/"
 :source {:url "https://ftp.gnu.org/gnu/patch/patch-2.8.1.tar.xz" :sha256 "3240c7959c5347c8ed347e3c4201c0337bf4240d5cf09d68889e58eeaba30e17"}
 :deps ["karate/glibc" "karate/attr"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/make" "karate/gcc" "karate/sed"]
 :bin_dirs ["bin"]
 :check (fn [b]
          (b:run ["make" "check"]))}
