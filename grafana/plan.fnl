;; grafana, ported from its plan.sh.
{:name "grafana"
 :origin "karate"
 :version "4.6.3"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "Grafana graphing app, dynamically finds prometheus data sources"
 :upstream_url "https://grafana.com/"
 :source {:url "https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana-4.6.3.linux-x64.tar.gz" :sha256 "037cf7678858c4a5b3632de7bea4c20475e081ff48c27c868be71e7b0a07c505" :filename "grafana-4.6.3.linux-x64.tar.gz"}
 :deps ["karate/glibc" "karate/bash" "karate/wget" "karate/curl" "karate/cacerts"]
 :build_deps ["karate/patchelf"]
 :bin_dirs ["bin"]
 :svc {:user "root" :group "root"}
 :exports {"grafana_port" "listening_port"}
 :exposes ["grafana_port"]
 :binds_optional {"prom" ["prom_ds_http"]}
 :build (fn [b]
          nil)
 :install (fn [b]
          (b:mkdir "/doj/svc/grafana/var/plugins")
          (b:copy (b:join (.. b.cache "/" b.name "-" b.version) "conf") (b:join (.. b.prefix "/") (: (b:join (.. b.cache "/" b.name "-" b.version) "conf") :match "[^/]+$")))
          (b:copy (b:join (.. b.cache "/" b.name "-" b.version) "public") (b:join (.. b.prefix "/") (: (b:join (.. b.cache "/" b.name "-" b.version) "public") :match "[^/]+$")))
          (b:copy (b:join (.. b.cache "/" b.name "-" b.version) "scripts") (b:join (.. b.prefix "/") (: (b:join (.. b.cache "/" b.name "-" b.version) "scripts") :match "[^/]+$")))
          (b:copy (b:join (.. b.cache "/" b.name "-" b.version) "vendor") (b:join (.. b.prefix "/") (: (b:join (.. b.cache "/" b.name "-" b.version) "vendor") :match "[^/]+$")))
          (each [_ p (ipairs (b:glob (b:join (.. b.cache "/" b.name "-" b.version) "bin") "*"))] (b:copy p (b:join (.. b.prefix "/bin/") (: p :match "[^/]+$"))))
          (b:run ["patchelf" "--interpreter" (.. (b:path_for "glibc") "/lib/ld-linux-x86-64.so.2") (.. b.prefix "/bin/grafana-server")] {:cwd (.. b.cache "/" b.name "-" b.version)})
          (b:run ["patchelf" "--interpreter" (.. (b:path_for "glibc") "/lib/ld-linux-x86-64.so.2") (.. b.prefix "/bin/grafana-cli")] {:cwd (.. b.cache "/" b.name "-" b.version)}))}
