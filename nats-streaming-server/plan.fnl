;; nats-streaming-server, ported from its plan.sh.
;; The plan's do_clean is not ported: a build empties its source directory before
;; unpacking and starts with no state from an earlier one.
(var v-parent-go-path "")
{:name :nats-streaming-server
 :origin :karate
 :version :0.10.2
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "NATS Streaming is an extremely performant, lightweight reliable streaming platform built on NATS."
 :upstream_url "https://github.com/nats-io/nats-streaming-server"
 :source {:url "https://github.com/nats-io/nats-streaming-server/archive/v0.10.2.tar.gz"
          :sha256 :7a5683a80bb389060c2da730f1f9f1468bc3a6fd1450c10270a39385908bbca0}
 :deps [:karate/glibc]
 :build_deps [:karate/go :karate/coreutils :karate/gcc :karate/make]
 :bin_dirs [:bin]
 :svc {:run :nats-streaming-server}
 :download (fn [b]
             ;; From do_begin.
             (b:env :GOPATH :/doj/cache)
             (set v-parent-go-path
                  (.. (or (b:getenv :GOPATH) "") :/src/github.com/nats-io))
             (b.default.download b))
 :prepare (fn [b]
            (b:mkdir v-parent-go-path)
            (let [link (if (b:exists (b:join (.. v-parent-go-path "/" b.name)
                                             "."))
                           (b:join (.. v-parent-go-path "/" b.name)
                                   (b.src:match "[^/]+$"))
                           (.. v-parent-go-path "/" b.name))]
              (b:symlink b.src link)))
 :build (fn [b]
          (b:run [:go :build] {:cwd (.. v-parent-go-path "/" b.name)}))
 :install (fn [b]
            (b:mkdir (.. b.prefix :/bin))
            (if (b:exists (.. b.prefix :/bin/ b.name))
                (b:copy b.name
                        (b:join (.. b.prefix :/bin/ b.name)
                                (b.name:match "[^/]+$")))
                (b:copy b.name (.. b.prefix :/bin/ b.name))))}
