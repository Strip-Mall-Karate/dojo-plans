;; bdwgc8, ported from its plan.sh.
;; Built from the bdwgc plan, with its own changes.
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

{:name :bdwgc8
 :origin :karate
 :version :8.0.2
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license ["X11 style license"]
 :description "A garbage collector for C and C++"
 :upstream_url "http://www.hboehm.info/gc/"
 :source {:url "http://www.hboehm.info/gc/gc_source/gc-8.0.2.tar.gz"
          :sha256 :4e8ca4b5b72a3a27971daefaa9b621f0a716695b23baa40b7eac78de2eeb51cb
          :dirname :gc-8.0.2}
 :deps [:karate/glibc]
 :build_deps [:karate/diffutils
              :karate/file
              :karate/gcc
              :karate/libatomic_ops
              :karate/make
              :karate/pkg-config]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]
 :prepare (fn [b]
            (use-dependency-path b :/usr/bin/file (b:path_for :file :bin/file)))
 :check (fn [b]
          (b:run [:make :check]))
 :strip (fn [b]
          (b.default.strip b)
          ;; From do_end.
          )}
