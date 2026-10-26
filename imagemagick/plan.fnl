;; imagemagick, ported from its plan.sh.
{:name "imagemagick"
 :origin "karate"
 :version "6.9.2-10"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache2"]
 :description "A software suite to create, edit, compose, or convert bitmap images."
 :upstream_url "http://imagemagick.org/"
 :source {:url "http://www.imagemagick.org/download/releases/ImageMagick-6.9.2-10.tar.xz" :sha256 "da2f6fba43d69f20ddb11783f13f77782b0b57783dde9cda39c9e5e733c2013c" :dirname "ImageMagick-6.9.2-10"}
 :deps ["karate/glibc" "karate/zlib" "karate/libpng" "karate/xz" "karate/gcc-libs"]
 :build_deps ["karate/zlib" "karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/sed" "karate/glibc" "karate/pkg-config"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include/ImageMagick-6"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix)] {:env {"CC" "gcc -std=gnu99"}})
          (b:run ["make"]))}
