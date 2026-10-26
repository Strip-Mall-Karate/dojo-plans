;; gnatsd, ported from its plan.sh.
;; The plan's do_clean is not ported: a build empties its source directory before
;; unpacking and starts with no state from an earlier one.
(var v-parent-go-path "")
{:name "gnatsd"
 :origin "karate"
 :version "1.4.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "A High Performance NATS Server written in Go."
 :upstream_url "https://github.com/nats-io/gnatsd"
 :source {:url "https://github.com/nats-io/gnatsd/archive/v1.4.0.tar.gz" :sha256 "193778c9c697823d5a198552236fb2f519d509213fbbbea77cd4341719066bfb"}
 :deps ["karate/glibc"]
 :build_deps ["karate/go" "karate/coreutils" "karate/gcc" "karate/make"]
 :bin_dirs ["bin"]
 :svc {:run "gnatsd -c /doj/svc/gnatsd/config/default.conf"}
 :exports {"port" "gnatsd.port" "http_port" "gnatsd.http.port"}
 :exposes ["port" "http_port"]
 :download (fn [b]
          ;; From do_begin.
          (b:env "GOPATH" "/doj/cache")
          (set v-parent-go-path (.. (or (b:getenv "GOPATH") "") "/src/github.com/nats-io"))
          (b.default.download b))
 :prepare (fn [b]
          (b:mkdir v-parent-go-path)
          (let [link (if (b:exists (b:join (.. v-parent-go-path "/" b.name) ".")) (b:join (.. v-parent-go-path "/" b.name) (: b.src :match "[^/]+$")) (.. v-parent-go-path "/" b.name))]
            (b:symlink b.src link)))
 :build (fn [b]
          (var v-code "")
          (b:run ["go" "build"] {:cwd (.. v-parent-go-path "/" b.name)})
          (set v-code "0"))
 :install (fn [b]
          (b:mkdir (.. b.prefix "/bin"))
          (if (b:exists (.. b.prefix "/bin/" b.name))
            (b:copy b.name (b:join (.. b.prefix "/bin/" b.name) (: b.name :match "[^/]+$")))
            (b:copy b.name (.. b.prefix "/bin/" b.name))))}
