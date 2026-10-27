;; yasm, ported from its plan.sh.
{:name :yasm
 :origin :karate
 :version :1.3.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Artistic-1.0-Perl :BSD-2-Clause :BSD-3-Clause :GPL-2.0 :LGPL-2.0]
 :description "Yasm is a complete rewrite of the NASM assembler"
 :upstream_url "http://yasm.tortall.net/"
 :source {:url "http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz"
          :sha256 :3dce6601b495f5b3d45b59f7d2492a340ee7e84b5beca17e48f862502bd5603f}
 :deps [:karate/glibc]
 :build_deps [:karate/diffutils :karate/gcc :karate/make]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :check (fn [b]
          (b:run [:make :check]))}
