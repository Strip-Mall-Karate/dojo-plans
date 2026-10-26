;; at-spi2-core, ported from its plan.sh.
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
{:name "at-spi2-core"
 :origin "karate"
 :version "2.26.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["LGPL-2.0"]
 :description "Service Provider Interface for the Assistive Technologies available on the GNOME platform"
 :upstream_url "https://wiki.linuxfoundation.org/accessibility/atk/at-spi/at-spi_on_d-bus"
 :source {:url "https://download.gnome.org/sources/at-spi2-core/2.26/at-spi2-core-2.26.2.tar.xz" :sha256 "c80e0cdf5e3d713400315b63c7deffa561032a6c37289211d8afcfaa267c2615"}
 :deps ["karate/dbus" "karate/glib" "karate/glibc" "karate/libffi" "karate/libiconv" "karate/pcre"]
 :build_deps ["karate/diffutils" "karate/file" "karate/gcc" "karate/gettext" "karate/make" "karate/perl" "karate/pkg-config"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :prepare (fn [b]
          (use-dependency-path b "/usr/bin/file" (b:path_for "file" "bin/file")))
 :strip (fn [b]
          (b.default.strip b)
          ;; From do_end.
          )}
