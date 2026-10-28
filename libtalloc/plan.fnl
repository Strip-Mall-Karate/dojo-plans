;; libtalloc, ported from its plan.sh.
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

{:name :libtalloc
 :origin :karate
 :version :2.1.14
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-3.0]
 :description "Talloc is a hierarchical, reference counted memory pool system with destructors. It is the core memory allocator used in Samba."
 :upstream_url "https://talloc.samba.org"
 :source {:url "https://www.samba.org/ftp/talloc/talloc-2.1.14.tar.gz"
          :sha256 :b185602756a628bac507fa8af8b9df92ace69d27c0add5dab93190ad7c3367ce
          :dirname :talloc-2.1.14}
 :deps [:karate/python2 :karate/glibc]
 :build_deps [:karate/gcc :karate/make :karate/coreutils :karate/pkg-config]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]
 :prepare (fn [b]
            (use-dependency-path b :/usr/bin/env
                                 (b:path_for :coreutils :bin/env)))
 :check (fn [b]
          (b:run [:make :check]))
 :strip (fn [b]
          (b.default.strip b)
          ;; From do_end.
          (b:run [:unlink :/usr/bin/env]))}
