;; giflib, ported from its plan.sh.
{:name :giflib
 :origin :karate
 :version :5.1.4
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "GIFLIB is a package of portable tools and library routines for working with GIF images.
Also commonly known as libgif."
 :upstream_url "http://giflib.sourceforge.net/"
 :source {:url "http://downloads.sourceforge.net/sourceforge/giflib/giflib-5.1.4.tar.gz"
          :sha256 :34a7377ba834397db019e8eb122e551a49c98f49df75ec3fcc92b9a794a4f6d1}
 :deps [:karate/glibc]
 :build_deps [:karate/diffutils :karate/gcc :karate/make]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :check (fn [b]
          (b:run [:make :check]))}
