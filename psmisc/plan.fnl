;; psmisc, ported from its plan.sh.
{:name "psmisc"
 :origin "karate"
 :version "23.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["gpl"]
 :description "The PSmisc package is a set of some small useful utilities that use the proc filesystem."
 :upstream_url "http://psmisc.sourceforge.net/index.html"
 :source {:url "http://downloads.sourceforge.net/psmisc/psmisc-23.1.tar.xz" :sha256 "2e84d474cf75dfbe3ecdacfb797bbfab71a35c7c2639d1b9f6d5f18b2149ba30"}
 :deps ["karate/glibc" "karate/ncurses"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc"]
 :bin_dirs ["bin"]}
