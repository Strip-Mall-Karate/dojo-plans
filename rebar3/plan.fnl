;; rebar3, ported from its plan.sh.
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

{:name :rebar3
 :origin :karate
 :version :3.9.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0]
 :description "rebar is an Erlang build tool that makes it easy to compile and test Erlang applications, port drivers and releases."
 :upstream_url "https://github.com/rebar/rebar3"
 :source {:url "https://github.com/erlang/rebar3/archive/3.9.0.tar.gz"
          :sha256 :9ea73ce4e60ad4b3108641eae73b4098fadb510142e672ad8e3a793f57e9f992}
 :deps [:karate/erlang :karate/busybox-static]
 :build_deps [:karate/coreutils]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :prepare (fn [b]
            (use-dependency-path b :/usr/bin/env
                                 (b:path_for :coreutils :bin/env)))
 :build (fn [b]
          (b:run [:./bootstrap]))
 :install (fn [b]
            (each [_ p (ipairs (b:glob (b:join b.src :_build/default) "*"))]
              (b:copy p (b:join b.prefix (p:match "[^/]+$"))))
            (if (b:exists b.prefix)
                (b:copy (b:join b.src :_build/prod/bin)
                        (b:join b.prefix
                                (: (b:join b.src :_build/prod/bin) :match
                                   "[^/]+$")))
                (b:copy (b:join b.src :_build/prod/bin) b.prefix))
            (b:fix_interpreter (b:glob (.. b.prefix :/bin) "*")
                               :karate/busybox-static :bin/env)
            (b:chmod (.. b.prefix :/bin/rebar3) :+x))
 :strip (fn [b]
          (b.default.strip b)
          ;; From do_end.
          )}
