;; foulkon, ported from its plan.sh.
;; The source project's plan fetched foulkon with `go get` and reset it to the
;; v0.4.0 tag; `make deps` then piped glide's installer from glide.sh into sh
;; (installing its newest release) and ran `glide install`, which fetches the
;; commits glide.lock names. This is the tag's archive, pinned, with glide
;; v0.13.2, the release current at the fork date, pinned and built in its place.
{:name "foulkon"
 :origin "karate"
 :version "v0.4.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "Authorization server written in Go"
 :upstream_url "https://github.com/Tecsisa/foulkon"
 :deps ["karate/postgresql"]
 :source {:url "https://github.com/Tecsisa/foulkon/archive/v0.4.0.tar.gz" :sha256 "d06f306b5d345a3b488334e2d5938eb21abea8a60a70acf6d1b299f90c6c8ae3" :filename "foulkon-v0.4.0.tar.gz"}
 :scaffolding "karate/scaffolding-go"
 :bin_dirs ["bin"]
 :exports {"port" "service.port" "host" "service.host"}
 :exposes ["port"]
 :binds_optional {"database" ["port" "superuser_name" "superuser_password"]}
 :download (fn [b]
             (b.default.download b)
             (b:download "https://github.com/Masterminds/glide/archive/v0.13.2.tar.gz"
                         "0886851af2437b161d47b279a32bef426577e7bec3f5acdadebe34549aae8270" "glide-v0.13.2.tar.gz"))
 :prepare (fn [b]
            ;; glide, which vendors what it needs, built into $GOPATH/bin.
            (b.scaffolding.env b)
            (let [dir (b:join (b.scaffolding.gopath b) "src/github.com/Masterminds/glide")]
              (b:remove dir)
              (b:mkdir dir)
              (b:run ["tar" "xf" (b:join b.cache "glide-v0.13.2.tar.gz") "--strip-components=1" "--no-same-owner"] {:cwd dir})
              (b:run ["go" "install" "github.com/Masterminds/glide"] {:cwd dir})))
 :build (fn [b]
          (b.scaffolding.env b)
          (let [dir (b.scaffolding.pkg_path b)]
            (b:log "glide install, make generate")
            (b:run ["glide" "install"] {:cwd dir})
            (b:run ["make" "generate"] {:cwd dir})
            (b:log "CGO_ENABLED=0 go install github.com/Tecsisa/foulkon/cmd/{worker,proxy}")
            (each [_ cmd (ipairs ["worker" "proxy"])]
              (b:run ["go" "install" (.. "github.com/Tecsisa/foulkon/cmd/" cmd)] {:cwd dir :env {"CGO_ENABLED" "0"}}))))
 :install (fn [b]
            (b:log "copying worker and proxy binary")
            (each [_ cmd (ipairs ["worker" "proxy"])]
              (b:copy (b:join (b.scaffolding.gopath b) "bin" cmd) (b:join b.prefix "bin" cmd))))}
