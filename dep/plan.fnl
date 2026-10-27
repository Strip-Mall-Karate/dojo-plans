;; dep, ported from its plan.sh.
;; The source project's plan fetched dep with `go get` and reset it to the
;; v0.5.0 tag. This is that tag's archive, pinned; dep vendors what it needs.
;; Its hack/build-all.bash reads the version and commit from git, which an
;; archive does not have, so this is that script's linux build with v0.5.0's
;; values, for the target's architecture where the plan named amd64.
{:name :dep
 :origin :karate
 :version :0.5.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:BSD-3-Clause]
 :description "Go dependency management tool"
 :upstream_url "https://github.com/golang/dep"
 :source {:url "https://github.com/golang/dep/archive/v0.5.0.tar.gz"
          :sha256 :65c31c8d51513dfabd25f1f37ecd22a38ab3bcdd5893bdf10f54941250e4f19d
          :filename :dep-v0.5.0.tar.gz}
 :scaffolding :karate/scaffolding-go
 :bin_dirs [:bin]
 :build (fn [b]
          (b.scaffolding.env b)
          (let [root (b.scaffolding.pkg_path b)
                arch (b.scaffolding.goarch b)
                date (b:capture [:date "+%Y-%m-%d"])
                flags (.. "-s -w -X main.commitHash=224a564 -X main.buildDate="
                          date
                          " -X main.version=v0.5.0 -X main.flagImportDuringSolve=false")]
            (b:mkdir (b:join root :release))
            (b:log (.. "Building for linux/" arch " with CGO_ENABLED=0"))
            (b:run [:go
                    :build
                    :-a
                    :-installsuffix
                    :cgo
                    :-ldflags
                    flags
                    :-o
                    (b:join root (.. :release/dep-linux- arch))
                    :./cmd/dep/]
                   {:cwd root :env {:GOARCH arch :GOOS :linux :CGO_ENABLED :0}})))
 :install (fn [b]
            (b:copy (b:join (b.scaffolding.pkg_path b)
                            (.. :release/dep-linux- (b.scaffolding.goarch b)))
                    (b:join b.prefix :bin/dep)))}
