;; gtk, ported from its plan.sh.
(fn use-dependency-path [b path replacement]
  ;; The source project's studio linked a dependency's tool to `path` for the
  ;; build. A Dojo build writes nothing outside itself, so the build's scripts
  ;; name the dependency's tool instead.
  (each [_ f (ipairs (b:find b.src "*"))]
    (let [name (: f :match "[^/]+$")]
      (when (and (or (: name :match :^configure) (: name :match :^Makefile)
                     (: name :match :^ltmain) (: name :match "%.in$")
                     (: name :match "%.am$") (: name :match "%.ac$")
                     (: name :match "%.m4$") (: name :match "%.mk$")
                     (: name :match "%.sh$") (: name :match "%.pl$")
                     (: name :match "%.py$"))
                 (not (b:exists (b:join f "."))))
        (let [text (b:read f)
              escaped (pick-values 1
                                   (: path :gsub "[%^%$%(%)%%%.%[%]%*%+%-%?]"
                                      "%%%0"))
              (fixed n) (: text :gsub escaped
                           (pick-values 1 (: replacement :gsub "%%" "%%%%")))]
          (when (> n 0) (b:write f fixed)))))))

{:name :gtk
 :origin :karate
 :version :3.22.22
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:LGPL-2.0]
 :description "GTK+, or the GIMP Toolkit, is a multi-platform toolkit for creating graphical user interfaces."
 :upstream_url "https://www.gtk.org"
 :source {:url "https://download.gnome.org/sources/gtk+/3.22/gtk+-3.22.22.tar.xz"
          :sha256 :862dc22c5e93cd800753e5e90dfdb3af0fc760a47f6ebd918ae19136d527c6cd
          :dirname :gtk+-3.22.22}
 :deps [:karate/at-spi2-core
        :karate/at-spi2-atk
        :karate/atk
        :karate/bzip2
        :karate/cairo
        :karate/dbus
        :karate/expat
        :karate/fontconfig
        :karate/freetype
        :karate/gcc-libs
        :karate/gdk-pixbuf
        :karate/glib
        :karate/glibc
        :karate/harfbuzz
        :karate/libepoxy
        :karate/libffi
        :karate/libice
        :karate/libiconv
        :karate/libpng
        :karate/libsm
        :karate/libxau
        :karate/libxcb
        :karate/libxdmcp
        :karate/libxext
        :karate/libxfixes
        :karate/libxi
        :karate/pango
        :karate/pcre
        :karate/pixman
        :karate/util-linux
        :karate/xlib
        :karate/zlib]
 :build_deps [:karate/diffutils
              :karate/file
              :karate/fixesproto
              :karate/gcc
              :karate/gettext
              :karate/inputproto
              :karate/json-glib
              :karate/kbproto
              :karate/libpthread-stubs
              :karate/libxslt
              :karate/make
              :karate/papi
              :karate/perl
              :karate/pkg-config
              :karate/renderproto
              :karate/xextproto
              :karate/xproto]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]
 :prepare (fn [b]
            (use-dependency-path b :/usr/bin/file (b:path_for :file :bin/file)))
 :build (fn [b]
          (b:run [:./configure (.. :--prefix= b.prefix) :--disable-xinerama])
          (b:run [:make]))
 :strip (fn [b]
          (b.default.strip b)
          ;; From do_end.
          )}
