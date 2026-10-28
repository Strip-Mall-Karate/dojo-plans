;; libpciaccess, ported from its plan.sh.
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

{:name :libpciaccess
 :origin :karate
 :version :0.14
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "Direct Rendering Manager"
 :upstream_url "https://dri.freedesktop.org/wiki/"
 :source {:url "https://www.x.org/archive/individual/lib/libpciaccess-0.14.tar.gz"
          :sha256 :8d86e64893917be3dfb1c5e837888d1275399c818783474002203d751312b03c}
 :deps [:karate/glibc]
 :build_deps [:karate/diffutils
              :karate/file
              :karate/gcc
              :karate/make
              :karate/pkg-config
              :karate/util-macros]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]
 :prepare (fn [b]
            (use-dependency-path b :/usr/bin/file (b:path_for :file :bin/file)))
 :strip (fn [b]
          (b.default.strip b)
          ;; From do_end.
          )}
