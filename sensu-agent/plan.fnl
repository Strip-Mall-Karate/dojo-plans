;; sensu-agent, ported from its plan.sh.
{:name "sensu-agent"
 :origin "karate"
 :version "2.0.0-beta.2-4"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "Sensu 2.0 Agent"
 :upstream_url "https://sensu.io"
 :source {:url "https://storage.googleapis.com/sensu-binaries/2.0.0-beta.2-4/linux/amd64/sensu-agent" :sha256 "5825044fa69edc27fc74769001076c716a855a82103224727438f3ec0bbe8f90" :filename "sensu-agent"}
 :deps ["karate/curl"]
 :bin_dirs ["bin"]
 :svc {:run "sensu-agent start -c /doj/svc/sensu-agent/config/agent.yml"}
 :binds_optional {"backend" ["port"]}
 :unpack (fn [b]
          nil)
 :build (fn [b]
          nil)
 :install (fn [b]
          (b:log "Installing sensu-agent binary")
          (b:chmod (.. b.cache "/sensu-agent") "+x")
          (b:copy (.. b.cache "/sensu-agent") (.. b.prefix "/bin/sensu-agent"))
          (b:chmod (.. b.prefix "/bin/sensu-agent") "755"))}
