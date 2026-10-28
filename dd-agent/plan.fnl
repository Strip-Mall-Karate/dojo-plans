;; dd-agent, ported from its plan.sh.
{:name :dd-agent
 :origin :karate
 :version :5.32.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:BSD-3-Clause]
 :description "The Datadog Agent"
 :upstream_url "https://github.com/datadog/dd-agent"
 :deps [:karate/python2 :karate/sysstat :karate/busybox-static]
 :build_deps [:karate/curl
              :karate/gcc
              :karate/git
              :karate/make
              :karate/openssl
              :karate/ruby
              :karate/python2
              :karate/sed
              :karate/tar]
 :bin_dirs [:dd-agent/bin :dd-agent/venv/bin]
 :lib_dirs [:dd-agent/venv/lib]
 :svc {:run :agent :user :root}
 :download (fn [b]
             ;; From do_begin.
             (b:env :DD_HOME (.. b.prefix :/dd-agent))
             (b:env :DD_START_AGENT :0)
             (b:env :DD_API_KEY "{{cfg.dd_api_key}}")
             (b.default.download b))
 :build (fn [b]
          (b:mkdir (or (b:getenv :DD_HOME) ""))
          (b:run [:env
                  (.. :PATH= (b:path_for :karate/tar) "/bin:"
                      (or (b:getenv :PATH) ""))
                  :sh
                  :-c
                  (b:capture [:curl
                              :-L
                              "https://raw.githubusercontent.com/DataDog/dd-agent/master/packaging/datadog-agent/source/setup_agent.sh"])])
          (b:fix_interpreter [(.. (or (b:getenv :DD_HOME) "") :/bin/agent)]
                             :karate/busybox-static :bin/env)
          (b:remove (.. (or (b:getenv :DD_HOME) "") :/logs))
          (let [link (if (b:exists (b:join (.. (or (b:getenv :DD_HOME) "")
                                               :/logs)
                                           "."))
                         (b:join (.. (or (b:getenv :DD_HOME) "") :/logs) :var)
                         (.. (or (b:getenv :DD_HOME) "") :/logs))]
            (b:symlink :/doj/svc/dd-agent/var link))
          (b:mkdir (.. b.prefix :/config))
          (if (b:exists (.. b.prefix :/config))
              (b:move (.. (or (b:getenv :DD_HOME) "") :/agent/datadog.conf)
                      (b:join (.. b.prefix :/config)
                              (: (.. (or (b:getenv :DD_HOME) "")
                                     :/agent/datadog.conf)
                                 :match "[^/]+$")))
              (b:move (.. (or (b:getenv :DD_HOME) "") :/agent/datadog.conf)
                      (.. b.prefix :/config)))
          (let [link (if (b:exists (b:join (.. (or (b:getenv :DD_HOME) "")
                                               :/agent/datadog.conf)
                                           "."))
                         (b:join (.. (or (b:getenv :DD_HOME) "")
                                     :/agent/datadog.conf)
                                 :datadog.conf)
                         (.. (or (b:getenv :DD_HOME) "") :/agent/datadog.conf))]
            (b:symlink :/doj/svc/dd-agent/config/datadog.conf link)))
 :install (fn [_b]
            nil)
 :strip (fn [_b]
          nil)}
