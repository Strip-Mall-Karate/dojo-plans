;; cairo, ported from its plan.sh.
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

{:name :cairo
 :origin :karate
 :version :1.16.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:LGPL-2.1 :MPL-1.1]
 :description "Cairo is a 2D graphics library with support for multiple output devices."
 :upstream_url "https://www.cairographics.org"
 :source {:url "https://www.cairographics.org/releases/cairo-1.16.0.tar.xz"
          :sha256 :5e7b29b3f113ef870d1e3ecf8adf21f923396401604bda16d44be45e66052331}
 :deps [:karate/bzip2
        :karate/expat
        :karate/fontconfig
        :karate/freetype
        :karate/gcc-libs
        :karate/glib
        :karate/glibc
        :karate/libffi
        :karate/libice
        :karate/libiconv
        :karate/libpng
        :karate/libsm
        :karate/libxau
        :karate/libxcb
        :karate/libxdmcp
        :karate/libxext
        :karate/lzo
        :karate/pcre
        :karate/pixman
        :karate/xlib
        :karate/zlib]
 :build_deps [:karate/diffutils
              :karate/file
              :karate/gcc
              :karate/make
              :karate/pkg-config
              :karate/xextproto
              :karate/xproto]
 :bin_dirs [:bin]
 :lib_dirs [:lib :lib/cairo]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]
 :prepare (fn [b]
            (use-dependency-path b :/usr/bin/file (b:path_for :file :bin/file)))
 :build (fn [b]
          (b:env :CFLAGS (.. "-Os " (or (b:getenv :CFLAGS) "")))
          (b:run [:./configure (.. :--prefix= b.prefix) :--enable-xlib])
          (b:run [:make]))
 :check (fn [b]
          (b:run [:make :test]))
 :strip (fn [b]
          (b.default.strip b)
          ;; From do_end.
          )}
