;; libiconv, ported from its plan.sh.
{:name "libiconv"
 :origin "karate"
 :version "1.14"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["gplv2"]
 :source {:url "http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz" :sha256 "72b24ded17d687193c3366d0ebe7cde1e6b18f0df8c55438ac95be39e8a30613" :filename "libiconv-1.14.tar.gz"}
 :deps ["karate/glibc"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["patch" "-p1" "-i" (.. b.plan_dir "/patches/libiconv-1.14_srclib_stdio.in.h-remove-gets-declarations.patch")])
          (b:run ["./configure" (.. "--prefix=" b.prefix)])
          (b:run ["make"]))}
