;; opa, ported from its plan.sh.
;; UNPORTED: do_download: $scaffolding_go_gopath
;; UNPORTED: do_download: after a cd or pushd that is not ported
;; UNPORTED: do_download: after a cd or pushd that is not ported
;; UNPORTED: do_download: after a cd or pushd that is not ported
;; UNPORTED: do_prepare: $scaffolding_go_gopath
;; UNPORTED: do_prepare: after a cd or pushd that is not ported
;; UNPORTED: do_prepare: after a cd or pushd that is not ported
;; UNPORTED: do_prepare: after a cd or pushd that is not ported
;; UNPORTED: do_build: $scaffolding_go_gopath
;; UNPORTED: do_build: after a cd or pushd that is not ported
;; UNPORTED: do_build: after a cd or pushd that is not ported
;; UNPORTED: do_install: $scaffolding_go_gopath
{:name "opa"
 :origin "karate"
 :version "0.10.3"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "Open Policy Agent (OPA) is a lightweight general-purpose policy engine that can be co-located with your service."
 :upstream_url "https://www.openpolicyagent.org/"
 :build_deps ["karate/bash"]
 :scaffolding "karate/scaffolding-go"
 :bin_dirs ["bin"]
 :exports {"address" "service.address"}
 :download (fn [b]
          (b:log "go get -d github.com/open-policy-agent/opa")
          (b:run ["go" "get" "-d" "github.com/open-policy-agent/opa"])
          ;; UNPORTED ($scaffolding_go_gopath):
          ;;   pushd "${scaffolding_go_gopath:?}/src/${gopkg}"
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   build_line "checking out $pkg_version"
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   git reset --hard "v${pkg_version}"
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   popd
          )
 :prepare (fn [b]
          ;; UNPORTED ($scaffolding_go_gopath):
          ;;   pushd "${scaffolding_go_gopath:?}/src/${gopkg}"
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   sed -e "s#\#\!/usr/bin/env bash#\#\!$(pkg_path_for bash)/bin/bash#" -i build/*.sh
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   sed -e "s#hostname -f#echo \"bldr.habitat.sh\"#" -i build/get-build-hostname.sh
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   popd
          )
 :build (fn [b]
          ;; UNPORTED ($scaffolding_go_gopath):
          ;;   pushd "${scaffolding_go_gopath:?}/src/${gopkg}"
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   PATH="${scaffolding_go_gopath:?}/bin:$PATH" make deps build
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   popd
          )
 :install (fn [b]
          (b:log "copying binary")
          ;; UNPORTED ($scaffolding_go_gopath):
          ;;   cp "${scaffolding_go_gopath:?}/src/${gopkg}/opa_linux_amd64" "${pkg_prefix}/bin/opa"
          )}
