;; shield-agent, ported from its plan.sh.
{:name :shield-agent
 :origin :karate
 :version :0.10.8
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "A standalone system that can perform backup and restore functions for a wide variety of pluggable data systems."
 :upstream_url "https://github.com/starkandwayne/shield"
 :source {:url "https://github.com/starkandwayne/shield/archive/v0.10.8.tar.gz"
          :sha256 :1d9f5c80f86d6e1d8e0971959068154dd7f5299f307e06b38c33f63f81ee413a
          :dirname :shield-0.10.8}
 :deps [:karate/bash
        :karate/bzip2
        :karate/cacerts
        :karate/coreutils
        :karate/curl
        :karate/glibc
        :karate/jq-static
        :karate/libarchive]
 :build_deps [:karate/gcc :karate/git :karate/go :karate/gox :karate/make]
 :bin_dirs [:bin]
 :svc {:user :root :group :root}
 :exports {:port :port}
 :exposes [:port]
 :binds_optional {:daemon [:port :provisioning_key]}
 :download (fn [b]
             ;; From do_begin.
             (b:env :SHIELD_SRC_PATH
                    (.. b.cache
                        :/shield-0.10.8/src/github.com/starkandwayne/shield))
             (b:env :GOPATH (.. b.cache :/shield-0.10.8))
             (b.default.download b))
 :prepare (fn [b]
            (b:remove (.. b.cache :/shield))
            (b:mkdir (.. b.cache :/shield))
            (each [_ p (ipairs (b:glob (.. b.cache :/shield-0.10.8) "*"))]
              (b:move p (b:join (.. b.cache :/shield/) (p:match "[^/]+$"))))
            (b:mkdir (or (b:getenv :SHIELD_SRC_PATH) ""))
            (each [_ p (ipairs (b:glob (.. b.cache :/shield) "*"))]
              (b:move p (b:join (or (b:getenv :SHIELD_SRC_PATH) "")
                                (p:match "[^/]+$"))))
            (b:env :PATH
                   (.. (or (b:getenv :PATH) "") ":" (or (b:getenv :GOPATH) "")
                       :/bin))
            (b:run [:git
                    :config
                    :--global
                    "url.git://github.com/.insteadOf"
                    "https://github.com/"])
            (b:run [:go :get :github.com/tools/godep])
            (b:run [:make :restore-deps]
                   {:cwd (or (b:getenv :SHIELD_SRC_PATH) "")}))
 :build (fn [b]
          (b:env :VERSION b.version)
          (b:run [:make :release] {:cwd (or (b:getenv :SHIELD_SRC_PATH) "")}))
 :install (fn [b]
            (b:run [:tar :-xvzf :shield-server-linux-amd64.tar.gz]
                   {:cwd (.. (or (b:getenv :SHIELD_SRC_PATH) "") :/artifacts)})
            (if (b:exists (.. b.prefix :/bin))
                (b:copy (b:join (.. (or (b:getenv :SHIELD_SRC_PATH) "")
                                    :/artifacts :/shield-server-linux-amd64)
                                :cli/shield)
                        (b:join (.. b.prefix :/bin)
                                (: (b:join (.. (or (b:getenv :SHIELD_SRC_PATH)
                                                   "")
                                               :/artifacts
                                               :/shield-server-linux-amd64)
                                           :cli/shield)
                                   :match "[^/]+$")))
                (b:copy (b:join (.. (or (b:getenv :SHIELD_SRC_PATH) "")
                                    :/artifacts :/shield-server-linux-amd64)
                                :cli/shield)
                        (.. b.prefix :/bin)))
            (if (b:exists (.. b.prefix :/bin))
                (b:copy (b:join (.. (or (b:getenv :SHIELD_SRC_PATH) "")
                                    :/artifacts :/shield-server-linux-amd64)
                                :agent/shield-agent)
                        (b:join (.. b.prefix :/bin)
                                (: (b:join (.. (or (b:getenv :SHIELD_SRC_PATH)
                                                   "")
                                               :/artifacts
                                               :/shield-server-linux-amd64)
                                           :agent/shield-agent)
                                   :match "[^/]+$")))
                (b:copy (b:join (.. (or (b:getenv :SHIELD_SRC_PATH) "")
                                    :/artifacts :/shield-server-linux-amd64)
                                :agent/shield-agent)
                        (.. b.prefix :/bin)))
            (if (b:exists (.. b.prefix :/plugins))
                (b:copy (b:join (.. (or (b:getenv :SHIELD_SRC_PATH) "")
                                    :/artifacts :/shield-server-linux-amd64)
                                :plugins)
                        (b:join (.. b.prefix :/plugins)
                                (: (b:join (.. (or (b:getenv :SHIELD_SRC_PATH)
                                                   "")
                                               :/artifacts
                                               :/shield-server-linux-amd64)
                                           :plugins)
                                   :match "[^/]+$")))
                (b:copy (b:join (.. (or (b:getenv :SHIELD_SRC_PATH) "")
                                    :/artifacts :/shield-server-linux-amd64)
                                :plugins)
                        (.. b.prefix :/plugins)))
            (if (b:exists (.. b.prefix :/bin))
                (b:copy (b:join (.. (or (b:getenv :SHIELD_SRC_PATH) "")
                                    :/artifacts :/shield-server-linux-amd64)
                                :daemon/shield-pipe)
                        (b:join (.. b.prefix :/bin)
                                (: (b:join (.. (or (b:getenv :SHIELD_SRC_PATH)
                                                   "")
                                               :/artifacts
                                               :/shield-server-linux-amd64)
                                           :daemon/shield-pipe)
                                   :match "[^/]+$")))
                (b:copy (b:join (.. (or (b:getenv :SHIELD_SRC_PATH) "")
                                    :/artifacts :/shield-server-linux-amd64)
                                :daemon/shield-pipe)
                        (.. b.prefix :/bin)))
            (b:fix_interpreter [(.. b.prefix :/bin/shield-pipe)] :karate/bash
                               :bin/bash))}
