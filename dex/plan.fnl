;; dex, ported from its plan.sh.
{:name "dex"
 :origin "karate"
 :version "2.15.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "OpenID Connect Identity (OIDC) and OAuth 2.0 Provider with Pluggable Connectors"
 :upstream_url "https://github.com/dexidp/dex"
 :deps ["karate/glibc"]
 :build_deps ["karate/go" "karate/git" "karate/gcc"]
 :bin_dirs ["bin"]
 :exports {"port" "service.port" "host" "service.host"}
 :download (fn [b]
          ;; From do_before.
          (b:env "GOPATH" (.. b.cache "/" (.. b.name "-" b.version))))
 :verify (fn [b]
          nil)
 :unpack (fn [b]
          (b:run ["git" "clone" "https://github.com/dexidp/dex" (.. (or (b:getenv "GOPATH") "") "/src/github.com/dexidp/dex")])
          (b:run ["git" "reset" "--hard" (.. "v" b.version)] {:cwd (.. (or (b:getenv "GOPATH") "") "/src/github.com/dexidp/dex")}))
 :prepare (fn [b]
          (b:env "GO_LDFLAGS" (.. "-w -X github.com/dexidp/dex/version.Version=v" b.version)))
 :build (fn [b]
          (b:run ["go" "build" "--ldflags" (or (b:getenv "GO_LDFLAGS") "") "-o" (.. b.prefix "/bin/dex") "github.com/dexidp/dex/cmd/dex"]))
 :install (fn [b]
          (if (b:exists b.prefix)
            (b:copy (.. (or (b:getenv "GOPATH") "") "/src/github.com/dexidp/dex/web") (b:join b.prefix (: (.. (or (b:getenv "GOPATH") "") "/src/github.com/dexidp/dex/web") :match "[^/]+$")))
            (b:copy (.. (or (b:getenv "GOPATH") "") "/src/github.com/dexidp/dex/web") b.prefix)))}
