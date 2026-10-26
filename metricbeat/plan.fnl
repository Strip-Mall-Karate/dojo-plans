;; metricbeat, ported from its plan.sh.
{:name "metricbeat"
 :origin "karate"
 :version "6.7.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "Metricbeat is a lightweight shipper for metrics with Elasticsearch."
 :upstream_url "https://elastic.co/products/beats/metricbeat"
 :deps ["karate/glibc"]
 :build_deps ["karate/go" "karate/git" "karate/make" "karate/gcc"]
 :bin_dirs ["bin"]
 :svc {:user "root" :group "root"}
 :download (fn [b]
          (b:env "GOPATH" (b:capture ["dirname" b.cache]))
          (b:run ["go" "get" "github.com/elastic/beats/metricbeat"])
          (b:run ["git" "checkout" (.. "v" b.version)] {:cwd (.. b.cache "/github.com/elastic/beats/metricbeat")}))
 :unpack (fn [b]
          nil)
 :build (fn [b]
          (b:run ["make"] {:cwd (.. b.cache "/github.com/elastic/beats/metricbeat")}))
 :install (fn [b]
          (b:copy (.. b.cache "/github.com/elastic/beats/metricbeat/" b.name) (.. b.prefix "/bin/" b.name))
          (b:chmod (.. b.prefix "/bin/" b.name) "755"))}
