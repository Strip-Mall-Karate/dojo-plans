;; texinfo, ported from its plan.sh.
{:name "texinfo"
 :origin "karate"
 :version "6.5"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["gplv3+"]
 :description "Texinfo is the official documentation format of the GNU project. It was invented by Richard Stallman and Bob Chassell many years ago, loosely based on Brian Reid's Scribe and other formatting languages of the time. It is used by many non-GNU projects as well."
 :upstream_url "http://www.gnu.org/software/texinfo/"
 :source {:url "http://ftp.gnu.org/gnu/texinfo/texinfo-6.5.tar.xz" :sha256 "77774b3f4a06c20705cc2ef1c804864422e3cf95235e965b1f00a46df7da5f62"}
 :deps ["karate/glibc" "karate/ncurses" "karate/perl"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/sed"]
 :bin_dirs ["bin"]
 :check (fn [b]
          (b:run ["make" "check"]))}
