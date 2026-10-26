;; alsa-lib, ported from its plan.sh.
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
{:name "alsa-lib"
 :origin "karate"
 :version "1.1.8"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["LGPL-2.1-or-later"]
 :description "The Advanced Linux Sound Architecture (ALSA) provides audio and MIDI functionality to the Linux operating system."
 :upstream_url "http://alsa-project.org/"
 :source {:url "ftp://ftp.alsa-project.org/pub/lib/alsa-lib-1.1.8.tar.bz2" :sha256 "3cdc3a93a6427a26d8efab4ada2152e64dd89140d981f6ffa003e85be707aedf"}
 :deps ["karate/glibc"]
 :build_deps ["karate/diffutils" "karate/file" "karate/gcc" "karate/m4" "karate/make"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :prepare (fn [b]
          (use-dependency-path b "/usr/bin/file" (b:path_for "file" "bin/file")))
 :check (fn [b]
          (b:run ["make" "check"]))
 :strip (fn [b]
          (b.default.strip b)
          ;; From do_end.
          )}
