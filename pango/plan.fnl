;; pango, ported from its plan.sh.
(fn use-dependency-path [b path replacement]
  ;; The source project's studio linked a dependency's tool to `path` for the
  ;; build. A Dojo build writes nothing outside itself, so the build's scripts
  ;; name the dependency's tool instead.
  (each [_ f (ipairs (b:find b.src "*"))]
    (let [name (f:match "[^/]+$")]
      (when (and (or (name:match :^configure) (name:match :^Makefile)
                     (name:match :^ltmain) (name:match "%.in$")
                     (name:match "%.am$") (name:match "%.ac$")
                     (name:match "%.m4$") (name:match "%.mk$")
                     (name:match "%.sh$") (name:match "%.pl$")
                     (name:match "%.py$"))
                 (not (b:exists (b:join f "."))))
        (let [text (b:read f)
              escaped (pick-values 1
                                   (path:gsub "[%^%$%(%)%%%.%[%]%*%+%-%?]"
                                              "%%%0"))
              (fixed n) (text:gsub escaped
                                   (pick-values 1
                                                (replacement:gsub "%%" "%%%%")))]
          (when (> n 0) (b:write f fixed)))))))

{:name :pango
 :origin :karate
 :version :1.40.13
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:LGPL]
 :description "Pango is a library for laying out and rendering of text, with an emphasis on internationalization."
 :upstream_url "http://www.pango.org"
 :source {:url "https://download.gnome.org/sources/pango/1.40/pango-1.40.13.tar.xz"
          :sha256 :f84e98db1078772ff4935b40a1629ff82ef0dfdd08d2cbcc0130c8c437857196}
 :deps [:karate/bzip2
        :karate/cairo
        :karate/expat
        :karate/fontconfig
        :karate/freetype
        :karate/gcc-libs
        :karate/glib
        :karate/glibc
        :karate/harfbuzz
        :karate/libffi
        :karate/libice
        :karate/libiconv
        :karate/libpng
        :karate/libsm
        :karate/libxau
        :karate/libxcb
        :karate/libxdmcp
        :karate/libxext
        :karate/pcre
        :karate/pixman
        :karate/xlib
        :karate/zlib]
 :build_deps [:karate/coreutils
              :karate/diffutils
              :karate/file
              :karate/gcc
              :karate/make
              :karate/perl
              :karate/pkg-config]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]
 :prepare (fn [b]
            (use-dependency-path b :/usr/bin/file
                                 (b:path_for :karate/file :bin/file)))}
