;; cerebro, ported from its plan.sh.
{:name :cerebro
 :origin :karate
 :version :0.8.3
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0]
 :description "Cerebro: Elasticsearch Administration"
 :upstream_url "https://github.com/lmenezes/cerebro"
 :source {:url "https://github.com/lmenezes/cerebro/releases/download/v0.8.3/cerebro-0.8.3.tgz"
          :sha256 :fdda73f7d56c4ead29590a8b1567d0bbfc3b39c14d2b7bde75a440954e2f435b
          :filename :cerebro-0.8.3.tgz}
 :deps [:karate/coreutils :karate/corretto8]
 :bin_dirs [:bin]
 :svc {:user :doj :group :doj}
 :exports {:port :port}
 :exposes [:port]
 :build (fn [b]
          nil)
 :install (fn [b]
            (each [_ p (ipairs (b:glob b.src "*"))]
              (b:copy p (b:join (.. b.prefix "/") (: p :match "[^/]+$"))))
            (b:mkdir (.. b.prefix :/logs))
            (b:fix_interpreter (b:glob (.. b.prefix :/bin) "*")
                               :karate/coreutils :bin/env))}
