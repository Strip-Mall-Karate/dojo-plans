;; buildkite-cli, ported from its plan.sh.
;; The plan's do_clean is not ported: a build empties its source directory before
;; unpacking and starts with no state from an earlier one.
(var v-parent-go-path "")
{:name :buildkite-cli
 :origin :karate
 :version :0.4.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "A command line interface for Buildkite"
 :upstream_url "https://buildkite.com"
 :source {:url "https://github.com/buildkite/cli/archive/v0.4.1.tar.gz"
          :sha256 :ce5dd83ccea247c0cf97aff2c4c16e4b94a7abcda1686907b1013a303914fa92
          :filename :buildkite-cli-0.4.1.tar.gz}
 :deps [:karate/glibc :karate/git :karate/buildkite-agent]
 :build_deps [:karate/go :karate/coreutils :karate/gcc]
 :bin_dirs [:bin]
 :download (fn [b]
             ;; From do_begin.
             (b:env :GOPATH :/doj/cache)
             (b:env :GO111MODULE :on)
             (set v-parent-go-path
                  (.. (or (b:getenv :GOPATH) "") :/src/github.com/buildkite))
             (b.default.download b))
 :unpack (fn [b]
           (b.default.unpack b)
           (if (b:exists (.. b.cache "/" b.name "-" b.version))
               (b:move (.. b.cache :/cli- b.version)
                       (b:join (.. b.cache "/" b.name "-" b.version)
                               (: (.. b.cache :/cli- b.version) :match "[^/]+$")))
               (b:move (.. b.cache :/cli- b.version)
                       (.. b.cache "/" b.name "-" b.version))))
 :prepare (fn [b]
            (b:mkdir v-parent-go-path)
            (let [link (if (b:exists (b:join (.. v-parent-go-path :/cli) "."))
                           (b:join (.. v-parent-go-path :/cli)
                                   (: b.src :match "[^/]+$"))
                           (.. v-parent-go-path :/cli))]
              (b:symlink b.src link)))
 :build (fn [b]
          (var v-code "")
          (b:run [:go :install :--tags :extended]
                 {:cwd (.. v-parent-go-path :/cli)})
          (b:run [:go :build :-o :bk :./cmd/bk/main.go]
                 {:cwd (.. v-parent-go-path :/cli)})
          (set v-code :0))
 :install (fn [b]
            (b:mkdir (.. b.prefix :/bin))
            (if (b:exists (.. b.prefix :/bin/bk))
                (b:copy (b:join b.src :bk)
                        (b:join (.. b.prefix :/bin/bk)
                                (: (b:join b.src :bk) :match "[^/]+$")))
                (b:copy (b:join b.src :bk) (.. b.prefix :/bin/bk))))}
