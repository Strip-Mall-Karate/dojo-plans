;; foulkon, ported from its plan.sh.
;; UNPORTED: do_download: pipeline or list
;; UNPORTED: do_download: $scaffolding_go_pkg_path
;; UNPORTED: do_download: after a cd or pushd that is not ported
;; UNPORTED: do_download: after a cd or pushd that is not ported
;; UNPORTED: do_build: $scaffolding_go_pkg_path
;; UNPORTED: do_build: after a cd or pushd that is not ported
;; UNPORTED: do_build: after a cd or pushd that is not ported
;; UNPORTED: do_build: after a cd or pushd that is not ported
;; UNPORTED: do_build: after a cd or pushd that is not ported
;; UNPORTED: do_build: after a cd or pushd that is not ported
;; UNPORTED: do_build: after a cd or pushd that is not ported
;; UNPORTED: do_install: $scaffolding_go_gopath
;; UNPORTED: do_install: $scaffolding_go_gopath
{:name "foulkon"
 :origin "karate"
 :version "v0.4.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "Authorization server written in Go"
 :upstream_url "https://github.com/Tecsisa/foulkon"
 :deps ["karate/postgresql"]
 :scaffolding "karate/scaffolding-go"
 :bin_dirs ["bin"]
 :exports {"port" "service.port" "host" "service.host"}
 :exposes ["port"]
 :binds_optional {"database" ["port" "superuser_name" "superuser_password"]}
 :download (fn [b]
          (b:log "go get -d github.com/Tecsisa/foulkon")
          ;; UNPORTED (pipeline or list):
          ;;   go get -d github.com/Tecsisa/foulkon 2>&1 | grep -q "no Go files"
          ;; UNPORTED ($scaffolding_go_pkg_path):
          ;;   pushd "$scaffolding_go_pkg_path"
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   git reset --hard $pkg_version
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   popd
          )
 :prepare (fn [b]
          (b:log "mkdir -p $GOPATH/bin; export PATH=$GOPATH/bin:$PATH")
          (b:mkdir (.. (or (b:getenv "GOPATH") "") "/bin"))
          (b:env "PATH" (.. (or (b:getenv "GOPATH") "") "/bin:" (or (b:getenv "PATH") ""))))
 :build (fn [b]
          ;; UNPORTED ($scaffolding_go_pkg_path):
          ;;   pushd "$scaffolding_go_pkg_path"
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   build_line "make deps generate"
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   make deps generate
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   build_line "CGO_ENABLED=0 go install github.com/Tecsisa/foulkon/cmd/{worker,proxy}"
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   CGO_ENABLED=0 go install github.com/Tecsisa/foulkon/cmd/worker
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   CGO_ENABLED=0 go install github.com/Tecsisa/foulkon/cmd/proxy
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   popd
          )
 :install (fn [b]
          (b:log "copying worker and proxy binary")
          ;; UNPORTED ($scaffolding_go_gopath):
          ;;   cp "${scaffolding_go_gopath:?}/bin/worker" "$pkg_prefix/bin"
          ;; UNPORTED ($scaffolding_go_gopath):
          ;;   cp "${scaffolding_go_gopath:?}/bin/proxy" "$pkg_prefix/bin"
          )}
