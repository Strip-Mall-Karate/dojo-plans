;; autoconf, ported from its plan.sh.
;; autoconf 2.73, the latest release on 2026-10-26.
{:name :autoconf
 :origin :karate
 :version :2.73
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-2.0]
 :description "Autoconf is an extensible package of M4 macros that produce shell scripts to automatically configure software source code packages."
 :upstream_url "https://www.gnu.org/software/autoconf/autoconf.html"
 :source {:url "https://ftp.gnu.org/gnu/autoconf/autoconf-2.73.tar.xz"
          :sha256 :9fd672b1c8425fac2fa67fa0477b990987268b90ff36d5f016dae57be0d6b52e}
 :deps [:karate/m4 :karate/perl]
 :build_deps [:karate/diffutils :karate/inetutils :karate/gcc :karate/make]
 :bin_dirs [:bin]}
