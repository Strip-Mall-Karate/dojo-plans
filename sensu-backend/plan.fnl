;; sensu-backend, ported from its plan.sh.
{:name "sensu-backend"
 :origin "karate"
 :version "2.0.0-beta.2-4"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "Sensu 2.0 Backend"
 :upstream_url "https://sensu.io"
 :source {:url "https://storage.googleapis.com/sensu-binaries/2.0.0-beta.2-4/linux/amd64/sensu-backend" :sha256 "c6aba03da9a60a3e2bfeaeeb9a5a4992d5d14407277681ac9f15543201b35a3a" :filename "sensu-backend"}
 :deps ["karate/curl"]
 :bin_dirs ["bin"]
 :svc {:run "sensu-backend start -c /doj/svc/sensu-backend/config/backend.yml"}
 :exports {"port" "agent-port"}
 :unpack (fn [b]
          nil)
 :build (fn [b]
          nil)
 :install (fn [b]
          (b:log "Installing sensu-backend binary")
          (b:chmod (.. b.cache "/sensu-backend") "+x")
          (b:copy (.. b.cache "/sensu-backend") (.. b.prefix "/bin/sensu-backend"))
          (b:chmod (.. b.prefix "/bin/sensu-backend") "755"))}
