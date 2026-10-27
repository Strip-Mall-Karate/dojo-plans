;; libiconv, ported from its plan.sh.
;; libiconv 1.19, the latest release on 2026-10-27: 1.14 does not build with gcc 16, and the
;; gets patch it needed is upstream.
{:name :libiconv
 :origin :karate
 :version :1.19
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:gplv2]
 :source {:url "https://ftp.gnu.org/gnu/libiconv/libiconv-1.19.tar.gz"
          :sha256 :88dd96a8c0464eca144fc791ae60cd31cd8ee78321e67397e25fc095c4a19aa6}
 :deps [:karate/glibc]
 :build_deps [:karate/coreutils
              :karate/diffutils
              :karate/patch
              :karate/make
              :karate/gcc]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :build (fn [b]
          (b:run [:./configure (.. :--prefix= b.prefix)])
          (b:run [:make (.. :-j (tostring b.jobs))]))}
