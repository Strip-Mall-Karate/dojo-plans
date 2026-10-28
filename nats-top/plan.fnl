;; nats-top, ported from its plan.sh.
;; The plan's do_clean is not ported: a build empties its source directory before
;; unpacking and starts with no state from an earlier one.
(var v-parent-go-path "")
{:name :nats-top
 :origin :karate
 :version :0.3.2
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "Top like program monitor for NATS."
 :upstream_url "https://github.com/nats-io/nats-top"
 :source {:url "https://github.com/nats-io/nats-top/archive/v0.3.2.tar.gz"
          :sha256 :98d0df8ebd3c0e0b4c6edc4f084520f643224d8a5d0519023c67c4d05db458b8}
 :deps [:karate/glibc]
 :build_deps [:karate/go :karate/coreutils :karate/gcc :karate/make]
 :bin_dirs [:bin]
 :svc {:run :nats-top}
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
