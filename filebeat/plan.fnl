;; filebeat, ported from its plan.sh.
{:name "filebeat"
 :origin "karate"
 :version "6.7.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "Lightweight shipper for logfiles"
 :upstream_url "https://www.elastic.co/products/beats/filebeat"
 :deps ["karate/glibc"]
 :build_deps ["karate/go" "karate/git" "karate/make" "karate/gcc"]
 :bin_dirs ["bin"]
 :binds_optional {"kibana" ["port"] "elasticsearch" ["http-port"] "logstash" ["port"]}
 :download (fn [b]
          (b:env "GOPATH" (b:capture ["dirname" b.cache]))
          (b:run ["go" "get" "github.com/elastic/beats/filebeat"])
          (b:run ["git" "checkout" (.. "v" b.version)] {:cwd (.. b.cache "/github.com/elastic/beats/filebeat")}))
 :unpack (fn [b]
          nil)
 :build (fn [b]
          (b:run ["make"] {:cwd (.. b.cache "/github.com/elastic/beats/filebeat")}))
 :install (fn [b]
          (b:copy (.. b.cache "/github.com/elastic/beats/filebeat/" b.name) (.. b.prefix "/bin/" b.name))
          (b:chmod (.. b.prefix "/bin/" b.name) "755"))}
