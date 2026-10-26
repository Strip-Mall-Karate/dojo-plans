;; certstrap, ported from its plan.sh.
;; UNPORTED: do_download: $scaffolding_go_pkg_path
;; UNPORTED: do_download: after a cd or pushd that is not ported
;; UNPORTED: do_download: after a cd or pushd that is not ported
;; UNPORTED: do_download: after a cd or pushd that is not ported
;; UNPORTED: do_prepare: $scaffolding_go_gopath
;; UNPORTED: do_build: $scaffolding_go_pkg_path
;; UNPORTED: do_build: after a cd or pushd that is not ported
;; UNPORTED: do_build: after a cd or pushd that is not ported
;; UNPORTED: do_build: after a cd or pushd that is not ported
;; UNPORTED: do_install: $scaffolding_go_pkg_path
{:name "certstrap"
 :origin "karate"
 :version "v1.1.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "A simple certificate manager written in Go, to bootstrap your own certificate authority and public key infrastructure. Adapted from etcd-ca."
 :upstream_url "https://github.com/square/certstrap"
 :scaffolding "karate/scaffolding-go"
 :bin_dirs ["bin"]
 :svc {:user "root" :group "root"}
 :download (fn [b]
          (b:log "go get -d github.com/square/certstrap")
          (b:run ["go" "get" "-d" "github.com/square/certstrap"])
          ;; UNPORTED ($scaffolding_go_pkg_path):
          ;;   pushd "${scaffolding_go_pkg_path:?}"
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   build_line "checking out $pkg_version"
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   git reset --hard $pkg_version
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   popd
          )
 :prepare (fn [b]
          (b:log "adding $GOPATH/bin to $PATH")
          ;; UNPORTED ($scaffolding_go_gopath):
          ;;   export PATH=${scaffolding_go_gopath:?}/bin:$PATH
          (b:log "building godep")
          (b:run ["go" "get" "github.com/tools/godep"]))
 :build (fn [b]
          ;; UNPORTED ($scaffolding_go_pkg_path):
          ;;   pushd "${scaffolding_go_pkg_path:?}"
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   build_line "building certstrap"
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   GOARCH=amd64 GOOS=linux go build -o bin/certstrap github.com/square/certstrap
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   popd
          )
 :install (fn [b]
          (b:log "copying certstrap binary")
          ;; UNPORTED ($scaffolding_go_pkg_path):
          ;;   cp "${scaffolding_go_pkg_path:?}/bin/certstrap" "${pkg_prefix}/bin"
          )}
