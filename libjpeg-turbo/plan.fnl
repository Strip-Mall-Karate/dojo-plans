;; libjpeg-turbo, ported from its plan.sh.
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
{:name "libjpeg-turbo"
 :origin "karate"
 :version "1.5.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["IJG" "BSD-3-Clause" "Zlib"]
 :description "A faster (using SIMD) libjpeg implementation"
 :upstream_url "http://libjpeg-turbo.virtualgl.org/"
 :source {:url "https://sourceforge.net/projects/libjpeg-turbo/files/1.5.0/libjpeg-turbo-1.5.0.tar.gz/download" :sha256 "9f397c31a67d2b00ee37597da25898b03eb282ccd87b135a50a69993b6a2035f" :filename "libjpeg-turbo-1.5.0.tar.gz"}
 :deps ["karate/glibc"]
 :build_deps ["karate/diffutils" "karate/file" "karate/gcc" "karate/make" "karate/nasm"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :prepare (fn [b]
          (use-dependency-path b "/usr/bin/file" (b:path_for "file" "bin/file")))
 :check (fn [b]
          (b:run ["make" "test"]))
 :strip (fn [b]
          (b.default.strip b)
          ;; From do_end.
          )}
