;; glib, ported from its plan.sh.
;; glib 2.90.1, the latest release on 2026-10-27: 2.50.3's autotools build does not build any more.
;; glib builds with meson since 2.62.
{:name "glib"
 :origin "karate"
 :version "2.90.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["LGPL-2.1-or-later"]
 :description "GLib is a general-purpose utility library, which provides many useful data\ntypes, macros, type conversions, string utilities, file utilities, a\nmainloop abstraction, and so on. It works on many UNIX-like platforms, as\nwell as Windows and OS X."
 :upstream_url "https://docs.gtk.org/glib/"
 :source {:url "https://download.gnome.org/sources/glib/2.90/glib-2.90.1.tar.xz" :sha256 "93c941aa17d5eb1d53fe838365f29a8b4e539c222a256d974ec8f30fc413e396"}
 :deps ["karate/coreutils" "karate/elfutils" "karate/glibc" "karate/libffi" "karate/pcre2" "karate/python" "karate/util-linux" "karate/zlib"]
 :build_deps ["karate/gcc" "karate/meson" "karate/ninja" "karate/pkg-config"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include/glib-2.0" "lib/glib-2.0/include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :interpreters ["karate/coreutils"]
 :build (fn [b]
          (b:run ["meson" "setup" "_build" (.. "--prefix=" b.prefix) "--libdir=lib" "--buildtype=release"
                  "-Dintrospection=disabled" "-Dtests=false" "-Dman-pages=disabled" "-Ddocumentation=false"
                  "-Dselinux=disabled" "-Dsysprof=disabled"])
          (b:run ["ninja" "-C" "_build" (.. "-j" (tostring b.jobs))]))
 :install (fn [b]
            (b:run ["ninja" "-C" "_build" "install"]))
 :strip (fn [b]
          (b.default.strip b)
          ;; The Python and shell programs in bin name /usr/bin/env.
          (b:fix_interpreter (b:glob (.. b.prefix "/bin") "*") "karate/coreutils" "bin/env"))}
