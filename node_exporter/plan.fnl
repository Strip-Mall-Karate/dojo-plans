;; node_exporter, ported from its plan.sh.
(var v-parent-go-path "")
{:name "node_exporter"
 :origin "karate"
 :version "0.14.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "Prometheus node exporter"
 :upstream_url "http://prometheus.io"
 :source {:url "https://github.com/prometheus/node_exporter/archive/v0.14.0.tar.gz" :sha256 "312d7e1c07d6a7548f2f116b983da87f7b3a7630f9332eb41c306fd71b2e6ec1"}
 :build_deps ["karate/go" "karate/git" "karate/make" "karate/gcc"]
 :bin_dirs ["bin"]
 :exports {"metric-http-port" "listening_port"}
 :exposes ["metric-http-port"]
 :download (fn [b]
          ;; From do_begin.
          (b:env "GOPATH" "/doj/cache")
          (set v-parent-go-path (.. (or (b:getenv "GOPATH") "") "/src/github.com/prometheus"))
          (b.default.download b))
 :prepare (fn [b]
          (b:mkdir v-parent-go-path)
          (b:symlink b.src (.. v-parent-go-path "/" b.name)))
 :build (fn [b]
          (var v-code "")
          (b:run ["go" "build" "."] {:cwd (.. v-parent-go-path "/" b.name)})
          (set v-code "0"))
 :install (fn [b]
          (b:copy (b:join b.src "node_exporter") (.. b.prefix "/bin/node_exporter"))
          (b:chmod (.. b.prefix "/bin/node_exporter") "755"))}
