;; imagemagick, ported from its plan.sh.
;; imagemagick 7.1.2-34, the latest release on 2026-10-26: 6.9.2-10's source no longer downloads.
{:name :imagemagick
 :origin :karate
 :version :7.1.2-34
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache2]
 :description "A software suite to create, edit, compose, or convert bitmap images."
 :upstream_url "http://imagemagick.org/"
 :source {:url "https://github.com/ImageMagick/ImageMagick/releases/download/7.1.2-34/ImageMagick-7.1.2-34.tar.xz"
          :sha256 :55fe0ec246245b46c429f9e6bc65294ad4a78a66b88abd9817971ca157856323
          :dirname :ImageMagick-7.1.2-34}
 :deps [:karate/glibc :karate/zlib :karate/libpng :karate/xz :karate/gcc-libs]
 :build_deps [:karate/zlib
              :karate/coreutils
              :karate/diffutils
              :karate/patch
              :karate/make
              :karate/gcc
              :karate/sed
              :karate/glibc
              :karate/pkg-config]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include/ImageMagick-7]
 :build (fn [b]
          (b:run [:./configure (.. :--prefix= b.prefix)]
                 {:env {:CC "gcc -std=gnu99"}})
          (b:run [:make]))}
