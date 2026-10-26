;; libcerf, ported from its plan.sh.
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
{:name "libcerf"
 :origin "karate"
 :version "1.5"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "Libcerf is a self-contained numeric library that\nprovides an efficient and accurate implementation of complex error\nfunctions, along with Dawson, Faddeeva, and Voigt functions"
 :upstream_url "http://apps.jcns.fz-juelich.de/doku/sc/libcerf"
 :source {:url "http://apps.jcns.fz-juelich.de/src/libcerf/old/libcerf-1.5.tgz" :sha256 "e36dc147e7fff81143074a21550c259b5aac1b99fc314fc0ae33294231ca5c86"}
 :deps ["karate/bzip2" "karate/expat" "karate/gcc-libs" "karate/glibc" "karate/jbigkit" "karate/xz"]
 :build_deps ["karate/diffutils" "karate/file" "karate/gcc" "karate/make"]
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
