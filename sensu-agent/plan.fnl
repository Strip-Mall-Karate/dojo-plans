;; sensu-agent, ported from its plan.sh.
;; sensu-agent 6.15.0, the latest release on 2026-10-26: 2.0.0-beta.2-4's source no longer downloads.
{:name :sensu-agent
 :origin :karate
 :version :6.15.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "Sensu 2.0 Agent"
 :upstream_url "https://sensu.io"
 :source {:url "https://s3-us-west-2.amazonaws.com/sensu.io/sensu-go/6.15.0/sensu-go_6.15.0_linux_amd64.tar.gz"
          :sha256 :f1432532ed96f13c29563adcafe49c6205228d20363b5124dea71eb6504f237a
          :filename :sensu-go_6.15.0_linux_amd64.tar.gz}
 :deps [:karate/curl]
 :bin_dirs [:bin]
 :svc {:run "sensu-agent start -c /doj/svc/sensu-agent/config/agent.yml"}
 :binds_optional {:backend [:port]}
 :unpack (fn [_b]
           nil)
 :build (fn [_b]
          nil)
 :install (fn [b]
            (b:log "Installing sensu-agent binary")
            (b:run [:tar
                    :-xzf
                    (.. b.cache :/sensu-go_ b.version :_linux_amd64.tar.gz)
                    :-C
                    b.cache
                    :sensu-agent])
            (b:chmod (.. b.cache :/sensu-agent) :+x)
            (b:copy (.. b.cache :/sensu-agent) (.. b.prefix :/bin/sensu-agent))
            (b:chmod (.. b.prefix :/bin/sensu-agent) :755))}
