;; findutils, ported from its plan.sh.
;; findutils 4.11.0, the latest release on 2026-10-26.
{:name :findutils
 :origin :karate
 :version :4.11.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:gplv3+]
 :description "The GNU Find Utilities are the basic directory searching utilities of the GNU operating system. These programs are typically used in conjunction with other programs to provide modular and powerful directory search and file locating capabilities to other commands."
 :upstream_url "http://www.gnu.org/software/findutils"
 :source {:url "https://ftp.gnu.org/gnu/findutils/findutils-4.11.0.tar.xz"
          :sha256 :bfd19cb06cc71f3352d567e90284d8cdac02ac89774bbeadf0b533b0c11432fd}
 :deps [:karate/glibc]
 :build_deps [:karate/coreutils
              :karate/diffutils
              :karate/patch
              :karate/make
              :karate/gcc
              :karate/sed]
 :bin_dirs [:bin]
 :build (fn [b]
          (b:run [:./configure
                  (.. :--prefix= b.prefix)
                  :--localstatedir=/doj/svc/findutils/var/locate])
          (b:run [:make]))
 :check (fn [b]
          (b:run [:make :check]))}
