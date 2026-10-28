;; handlebars-cmd, ported from its plan.sh.
{:name :handlebars-cmd
 :origin :karate
 :version :0.1.4
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "handlebars command-line tool."
 :upstream_url "https://github.com/DavidBabel/handlebars-cmd"
 :deps [:karate/coreutils :karate/node]
 :build_deps [:karate/git]
 :bin_dirs [:bin]
 :download (fn [_b]
             nil)
 :verify (fn [_b]
           nil)
 :unpack (fn [_b]
           nil)
 :prepare (fn [b]
            (b:run [:npm :config :set :progress :false])
            (b:run [:npm :config :set :prefix b.prefix]))
 :build (fn [_b]
          nil)
 :install (fn [b]
            (b:run [:npm :install :-g (.. :DavidBabel/ b.name "#bc510fc")])
            (b:fix_interpreter [(.. b.prefix :/bin/handlebars)]
                               :karate/coreutils :bin/env))}
