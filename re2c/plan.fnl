;; re2c, ported from its plan.sh.
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

{:name :re2c
 :origin :karate
 :version :1.1.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:PDDL-1.0]
 :description "re2c is a lexer generator for C/C++."
 :upstream_url "http://re2c.org/"
 :source {:url "https://github.com/skvadrik/re2c/releases/download/1.1.1/re2c-1.1.1.tar.gz"
          :sha256 :856597337ea00b24ce91f549f79e6eece1b92ba5f8b63292cad66c14ac7451cf
          :filename :re2c-1.1.1.tar.bz2}
 :deps [:karate/gcc-libs]
 :build_deps [:karate/coreutils :karate/diffutils :karate/gcc :karate/make]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :prepare (fn [b]
            (use-dependency-path b :/usr/bin/env
                                 (b:path_for :coreutils :bin/env)))
 :check (fn [b]
          (b:run [:make :check]))
 :strip (fn [b]
          (b.default.strip b)
          ;; From do_end.
          )}
