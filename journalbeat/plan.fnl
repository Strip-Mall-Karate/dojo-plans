;; journalbeat, ported from its plan.sh.
{:name "journalbeat"
 :origin "karate"
 :version "6.7.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "Journalbeat is a lightweight journald log shipper for Elasticsearch."
 :upstream_url "https://github.com/elastic/beats/tree/master/journalbeat"
 :deps ["karate/glibc" "karate/systemd"]
 :build_deps ["karate/go" "karate/git" "karate/make" "karate/gcc"]
 :bin_dirs ["bin"]
 :svc {:user "root" :group "root"}
 :build (fn [b]
          (var v-systemd-include-path (.. (b:path_for "karate/systemd") "/include"))
          (b:env "GOPATH" (or (: (: b.cache :gsub "/+$" "") :match "^(.*)/[^/]*$") "."))
          (b:run ["go" "get" "github.com/elastic/beats/journalbeat"] {:env {"CGO_CFLAGS" (.. "-I" v-systemd-include-path)}})
          (b:run ["git" "checkout" (.. "v" b.version)] {:cwd (.. b.cache "/github.com/elastic/beats/journalbeat")})
          (b:run ["go" "build" "github.com/elastic/beats/journalbeat"] {:cwd (.. b.cache "/github.com/elastic/beats/journalbeat") :env {"CGO_CFLAGS" (.. "-I" v-systemd-include-path)}}))
 :install (fn [b]
          (b:copy (.. b.cache "/github.com/elastic/beats/journalbeat/" b.name) (.. b.prefix "/bin/" b.name))
          (b:chmod (.. b.prefix "/bin/" b.name) "755"))}
