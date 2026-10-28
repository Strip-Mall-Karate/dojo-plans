;; libxcomposite, ported from its plan.sh.
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

{:name :libxcomposite
 :origin :karate
 :version :0.4.4
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "X11 C Bindings for Composite extension"
 :upstream_url "https://www.x.org/"
 :source {:url "https://www.x.org/releases/individual/lib/libXcomposite-0.4.4.tar.bz2"
          :sha256 :ede250cd207d8bee4a338265c3007d7a68d5aca791b6ac41af18e9a2aeb34178
          :dirname :libXcomposite-0.4.4}
 :deps [:karate/glibc
        :karate/libxau
        :karate/libxcb
        :karate/libxdmcp
        :karate/xlib]
 :build_deps [:karate/compositeproto
              :karate/diffutils
              :karate/file
              :karate/fixesproto
              :karate/gcc
              :karate/kbproto
              :karate/libpthread-stubs
              :karate/libxfixes
              :karate/make
              :karate/pkg-config
              :karate/xextproto
              :karate/xproto]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]
 :prepare (fn [b]
            (use-dependency-path b :/usr/bin/file (b:path_for :file :bin/file)))
 :strip (fn [b]
          (b.default.strip b)
          ;; From do_end.
          )}
