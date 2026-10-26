;; texinfo, ported from its plan.sh.
;; texinfo 7.3, the latest release on 2026-10-26.
{:name "texinfo"
 :origin "karate"
 :version "7.3"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["gplv3+"]
 :description "Texinfo is the official documentation format of the GNU project. It was invented by Richard Stallman and Bob Chassell many years ago, loosely based on Brian Reid's Scribe and other formatting languages of the time. It is used by many non-GNU projects as well."
 :upstream_url "http://www.gnu.org/software/texinfo/"
 :source {:url "https://ftp.gnu.org/gnu/texinfo/texinfo-7.3.tar.xz" :sha256 "51f74eb0f51cfa9873b85264dfdd5d46e8957ec95b88f0fb762f63d9e164c72e"}
 :deps ["karate/glibc" "karate/ncurses" "karate/perl"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/sed"]
 :bin_dirs ["bin"]
 :check (fn [b]
          (b:run ["make" "check"]))}
