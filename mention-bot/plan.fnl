;; mention-bot, ported from its plan.sh.
;; Deprecated: true
{:name :mention-bot
 :origin :karate
 :version :3.0.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:BSD-3-Clause]
 :description "Automatically mention potential reviewers on pull requests."
 :upstream_url "https://github.com/facebook/mention-bot"
 :source {:url "https://github.com/facebook/mention-bot/archive/de2a15da302aad07fb246c2f5c4be85fbf2e65dd.tar.gz"
          :sha256 :2aae8e7b0b2e5e0695ec6a88a6f5ae6b3c3badae94fe49e6c9c637164e3f4df3
          :dirname :mention-bot-de2a15da302aad07fb246c2f5c4be85fbf2e65dd}
 :deps [:karate/elfutils :karate/node]
 :build_deps [:karate/glibc :karate/node :karate/patchelf]
 :exports {:port :port}
 :exposes [:port]
 :prepare (fn [b]
            (b:run [:npm :config :set :spin=false]))
 :build (fn [b]
          nil)
 :install (fn [b]
            (if (b:exists b.prefix)
                (b:copy b.src (b:join b.prefix (: b.src :match "[^/]+$")))
                (b:copy b.src b.prefix))
            (b:run [:npm :install :flow-bin] {:cwd b.prefix})
            (b:run [:patchelf
                    :--interpreter
                    (.. (b:path_for :glibc) :/lib/ld-linux-x86-64.so.2)
                    :--set-rpath
                    (or (b:getenv :LD_RUN_PATH) "")
                    :./node_modules/flow-bin/vendor/flow]
                   {:cwd b.prefix})
            (b:run [:npm :install] {:cwd b.prefix})
            (b:run [:npm :shrinkwrap] {:cwd b.prefix}))}
