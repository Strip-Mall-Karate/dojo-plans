;; buildkite-agent, ported from its plan.sh.
;; The plan's do_clean is not ported: a build empties its source directory before
;; unpacking and starts with no state from an earlier one.
(var v-parent-go-path "")
{:name "buildkite-agent"
 :origin "karate"
 :version "3.9.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "The Buildkite Agent is an open-source toolkit written in Golang for securely running build jobs on any device or network."
 :upstream_url "https://buildkite.com"
 :source {:url "https://github.com/buildkite/agent/archive/v3.9.1.zip" :sha256 "117e4aea220c8abe4806fb2e1d7b8ae54ce488e7a1bd98853d76346825b9742b" :filename "buildkite-agent-3.9.1.zip"}
 :deps ["karate/glibc"]
 :build_deps ["karate/go" "karate/coreutils" "karate/gcc"]
 :bin_dirs ["bin"]
 :download (fn [b]
          ;; From do_begin.
          (b:env "GOPATH" "/doj/cache")
          (set v-parent-go-path (.. (or (b:getenv "GOPATH") "") "/src/github.com/buildkite"))
          (b.default.download b))
 :unpack (fn [b]
          (b.default.unpack b)
          (if (b:exists (.. b.cache "/" b.name "-" b.version))
            (b:move (.. b.cache "/agent-" b.version) (b:join (.. b.cache "/" b.name "-" b.version) (: (.. b.cache "/agent-" b.version) :match "[^/]+$")))
            (b:move (.. b.cache "/agent-" b.version) (.. b.cache "/" b.name "-" b.version))))
 :prepare (fn [b]
          (b:mkdir v-parent-go-path)
          (b:symlink b.src (.. v-parent-go-path "/agent")))
 :build (fn [b]
          (var v-code "")
          (b:run ["go" "install" "--tags" "extended"] {:cwd (.. v-parent-go-path "/agent")})
          (b:run ["go" "build" "-o" "buildkite-agent" "main.go"] {:cwd (.. v-parent-go-path "/agent")})
          (set v-code "0"))
 :install (fn [b]
          (b:mkdir (.. b.prefix "/bin"))
          (if (b:exists (.. b.prefix "/bin/" b.name))
            (b:copy b.name (b:join (.. b.prefix "/bin/" b.name) (: b.name :match "[^/]+$")))
            (b:copy b.name (.. b.prefix "/bin/" b.name))))}
