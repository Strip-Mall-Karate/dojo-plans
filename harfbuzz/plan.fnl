;; harfbuzz, ported from its plan.sh.
{:name "harfbuzz"
 :origin "karate"
 :version "1.3.4"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "HarfBuzz is an OpenType text shaping engine"
 :upstream_url "https://www.freedesktop.org/wiki/Software/HarfBuzz/"
 :source {:url "http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.3.4.tar.bz2" :sha256 "718aa6fcadef1a6548315b8cfe42cc27e926256302c337f42df3a443843f6a2b"}
 :deps ["karate/bzip2" "karate/cairo" "karate/expat" "karate/freetype" "karate/fontconfig" "karate/gcc-libs" "karate/glib" "karate/glibc" "karate/icu" "karate/libffi" "karate/libiconv" "karate/libpng" "karate/libxau" "karate/libxcb" "karate/libxdmcp" "karate/libxext" "karate/pcre" "karate/pixman" "karate/xlib" "karate/zlib"]
 :build_deps ["karate/gcc" "karate/make" "karate/perl" "karate/pkg-config"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include/harfbuzz"]
 :pconfig_dirs ["lib/pkgconfig"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--with-gobject=yes"])
          (b:run ["make"]))}
