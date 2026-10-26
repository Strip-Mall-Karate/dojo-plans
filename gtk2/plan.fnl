;; gtk2, ported from its plan.sh.
{:name "gtk2"
 :origin "karate"
 :version "2.24.31"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["LGPL-2.0"]
 :description "GTK+, or the GIMP Toolkit, is a multi-platform toolkit for creating graphical user interfaces."
 :upstream_url "https://www.gtk.org"
 :source {:url "https://download.gnome.org/sources/gtk+/2.24/gtk+-2.24.31.tar.xz" :sha256 "68c1922732c7efc08df4656a5366dcc3afdc8791513400dac276009b40954658" :dirname "gtk+-2.24.31"}
 :deps ["karate/atk" "karate/bzip2" "karate/cairo" "karate/expat" "karate/fontconfig" "karate/freetype" "karate/gcc-libs" "karate/gdk-pixbuf" "karate/glib" "karate/glibc" "karate/harfbuzz" "karate/libffi" "karate/libiconv" "karate/libpng" "karate/libxau" "karate/libxcb" "karate/libxdmcp" "karate/libxext" "karate/libxrender" "karate/pango" "karate/pcre" "karate/pixman" "karate/util-linux" "karate/xlib" "karate/zlib"]
 :build_deps ["karate/gcc" "karate/kbproto" "karate/make" "karate/perl" "karate/pkg-config" "karate/renderproto" "karate/shared-mime-info" "karate/xextproto" "karate/xproto"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :prepare (fn [b]
          (b.default.prepare b)
          (var v-xdg-data-dirs (.. (or (b:getenv "XDG_DATA_DIRS") "") ":" (b:path_for "karate/shared-mime-info") "/share"))
          (b:env "XDG_DATA_DIRS" v-xdg-data-dirs))
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--disable-glibtest" "--disable-xinerama"])
          (b:run ["make"]))}
