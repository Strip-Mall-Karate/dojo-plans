;; at-spi2-atk, ported from its plan.sh.
{:name :at-spi2-atk
 :origin :karate
 :version :2.26.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:LGPL-2.0]
 :description "Service Provider Interface for the Assistive Technologies available on the GNOME platform"
 :upstream_url "https://wiki.linuxfoundation.org/accessibility/atk/at-spi/at-spi_on_d-bus"
 :source {:url "https://download.gnome.org/sources/at-spi2-atk/2.26/at-spi2-atk-2.26.1.tar.xz"
          :sha256 :b4f0c27b61dbffba7a5b5ba2ff88c8cee10ff8dac774fa5b79ce906853623b75}
 :deps [:karate/at-spi2-core
        :karate/atk
        :karate/dbus
        :karate/glib
        :karate/glibc
        :karate/libffi
        :karate/libiconv
        :karate/pcre]
 :build_deps [:karate/diffutils :karate/gcc :karate/make :karate/pkg-config]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]}
