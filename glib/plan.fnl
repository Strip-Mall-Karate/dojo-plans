;; glib, ported from its plan.sh.
(fn use-dependency-path [b path replacement]
  ;; The source project's studio linked a dependency's tool to `path` for the
  ;; build. A Dojo build writes nothing outside itself, so the build's scripts
  ;; name the dependency's tool instead.
  (each [_ f (ipairs (b:find b.src "*"))]
    (let [name (: f :match "[^/]+$")]
      (when (and (or (: name :match "^configure") (: name :match "^Makefile") (: name :match "^ltmain")
                     (: name :match "%.in$") (: name :match "%.am$") (: name :match "%.ac$")
                     (: name :match "%.m4$") (: name :match "%.mk$") (: name :match "%.sh$")
                     (: name :match "%.pl$") (: name :match "%.py$"))
                 (not (b:exists (b:join f "."))))
        (let [text (b:read f)
              escaped (pick-values 1 (: path :gsub "[%^%$%(%)%%%.%[%]%*%+%-%?]" "%%%0"))
              (fixed n) (: text :gsub escaped (pick-values 1 (: replacement :gsub "%%" "%%%%")))]
          (when (> n 0) (b:write f fixed)))))))
{:name "glib"
 :origin "karate"
 :version "2.50.3"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["LGPL-2.0"]
 :description "GLib is a general-purpose utility library, which provides many useful data\ntypes, macros, type conversions, string utilities, file utilities, a\nmainloop abstraction, and so on. It works on many UNIX-like platforms, as\nwell as Windows and OS X."
 :upstream_url "https://developer.gnome.org/glib/"
 :source {:url "https://download.gnome.org/sources/glib/2.50/glib-2.50.3.tar.xz" :sha256 "82ee94bf4c01459b6b00cb9db0545c2237921e3060c0b74cff13fbc020cfd999"}
 :deps ["karate/coreutils" "karate/elfutils" "karate/glibc" "karate/libffi" "karate/libiconv" "karate/pcre" "karate/python" "karate/util-linux" "karate/zlib"]
 :build_deps ["karate/dbus" "karate/diffutils" "karate/file" "karate/gcc" "karate/gettext" "karate/libxslt" "karate/make" "karate/perl" "karate/pkg-config"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :interpreters ["karate/coreutils"]
 :prepare (fn [b]
          (use-dependency-path b "/usr/bin/file" (b:path_for "file" "bin/file")))
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--with-libiconv" "--disable-gtk-doc" "--disable-fam"])
          (b:run ["make"]))
 :strip (fn [b]
          (b.default.strip b)
          ;; From do_after.
          (b:fix_interpreter [(.. b.prefix "/bin/*")] "karate/coreutils" "bin/env")
          ;; From do_end.
          )}
