;; libuv, ported from its plan.sh.
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

{:name :libuv
 :origin :karate
 :version :1.27.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "libuv is a multi-platform support library with a focus on asynchronous I/O."
 :upstream_url "http://libuv.org/"
 :source {:url "https://github.com/libuv/libuv/archive/v1.27.0.tar.gz"
          :sha256 :4afcdc84cd315b77c8e532e7b3fde43d536af0e2e835eafbd0e75518ed26dbed}
 :deps [:karate/glibc]
 :build_deps [:karate/autoconf
              :karate/automake
              :karate/diffutils
              :karate/file
              :karate/gcc
              :karate/libtool
              :karate/m4
              :karate/make]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :prepare (fn [b]
            (use-dependency-path b :/usr/bin/file (b:path_for :file :bin/file)))
 :build (fn [b]
          (b:run [:sh :autogen.sh])
          (b.default.build b))
 :check (fn [b]
          (b:run [:make :check]))
 :strip (fn [b]
          (b.default.strip b)
          ;; From do_end.
          )}
