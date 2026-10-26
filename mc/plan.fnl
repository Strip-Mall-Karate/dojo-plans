;; mc, ported from its plan.sh.
{:name "mc"
 :origin "karate"
 :version "4.8.21"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-3.0"]
 :description "Midnight Commander."
 :upstream_url "https://www.midnight-commander.org"
 :source {:url "http://ftp.midnight-commander.org/mc-4.8.21.tar.xz" :sha256 "8f37e546ac7c31c9c203a03b1c1d6cb2d2f623a300b86badfd367e5559fe148c"}
 :deps ["karate/glib" "karate/glibc" "karate/ncurses" "karate/pcre"]
 :build_deps ["karate/check" "karate/coreutils" "karate/diffutils" "karate/gcc" "karate/gettext" "karate/make" "karate/perl" "karate/pkg-config"]
 :bin_dirs ["bin"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--with-screen=ncurses" (.. "--with-ncurses-libs=" (b:path_for "ncurses") "/lib") "--without-subshell" "--without-x" "--without-gpm-mouse"])
          (b:run ["make"]))}
