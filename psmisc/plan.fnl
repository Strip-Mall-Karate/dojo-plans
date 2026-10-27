;; psmisc, ported from its plan.sh.
;; psmisc 23.7, the latest release on 2026-10-26.
{:name :psmisc
 :origin :karate
 :version :23.7
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:gpl]
 :description "The PSmisc package is a set of some small useful utilities that use the proc filesystem."
 :upstream_url "http://psmisc.sourceforge.net/index.html"
 :source {:url "https://downloads.sourceforge.net/project/psmisc/psmisc/psmisc-23.7.tar.xz"
          :sha256 :58c55d9c1402474065adae669511c191de374b0871eec781239ab400b907c327}
 :deps [:karate/glibc :karate/ncurses]
 :build_deps [:karate/coreutils
              :karate/diffutils
              :karate/patch
              :karate/make
              :karate/gcc]
 :bin_dirs [:bin]}
