;; gdk-pixbuf, ported from its plan.sh.
{:name :gdk-pixbuf
 :origin :karate
 :version :2.36.11
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-2.0]
 :description "An image loading library."
 :upstream_url "https://developer.gnome.org/gdk-pixbuf/"
 :source {:url "https://download.gnome.org/sources/gdk-pixbuf/2.36/gdk-pixbuf-2.36.11.tar.xz"
          :sha256 :ae62ab87250413156ed72ef756347b10208c00e76b222d82d9ed361ed9dde2f3}
 :deps [:karate/coreutils
        :karate/glib
        :karate/glibc
        :karate/jbigkit
        :karate/libffi
        :karate/libiconv
        :karate/libjpeg-turbo
        :karate/libpng
        :karate/libtiff
        :karate/pcre
        :karate/shared-mime-info
        :karate/util-linux
        :karate/xz
        :karate/zlib]
 :build_deps [:karate/gcc :karate/make :karate/perl :karate/pkg-config]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]}
