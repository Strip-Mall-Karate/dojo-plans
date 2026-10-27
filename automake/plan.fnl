;; automake, ported from its plan.sh.
;; automake 1.19, the latest release on 2026-10-26.
{:name :automake
 :origin :karate
 :version :1.19
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-2.0]
 :description "Automake is a tool for automatically generating Makefile.in files compliant with the GNU Coding Standards."
 :upstream_url "https://www.gnu.org/software/automake/"
 :source {:url "https://ftp.gnu.org/gnu/automake/automake-1.19.tar.xz"
          :sha256 :e3e2c2e3abf37898138db5b6c1d1dc35c9160c5978be7947d2c741705251d445}
 :deps [:karate/perl]
 :build_deps [:karate/autoconf
              :karate/bison
              :karate/coreutils
              :karate/diffutils
              :karate/flex
              :karate/gcc
              :karate/make]
 :bin_dirs [:bin]}
