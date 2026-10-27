;; which, ported from its plan.sh.
{:name :which
 :origin :karate
 :version :2.21
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-3.0]
 :source {:url "http://ftp.gnu.org/gnu/which/which-2.21.tar.gz"
          :sha256 :f4a245b94124b377d8b49646bf421f9155d36aa7614b6ebf83705d3ffc76eaad}
 :build_deps [:karate/make :karate/gcc]
 :bin_dirs [:bin]}
