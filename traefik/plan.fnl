;; traefik, ported from its plan.sh.
;; UNPORTED: do_download: $scaffolding_go_gopath
;; UNPORTED: do_download: after a cd or pushd that is not ported
;; UNPORTED: do_download: after a cd or pushd that is not ported
;; UNPORTED: do_prepare: $scaffolding_go_gopath
;; UNPORTED: do_build: $scaffolding_go_gopath
;; UNPORTED: do_build: after a cd or pushd that is not ported
;; UNPORTED: do_build: after a cd or pushd that is not ported
;; UNPORTED: do_build: after a cd or pushd that is not ported
;; UNPORTED: do_build: after a cd or pushd that is not ported
;; UNPORTED: do_build: after a cd or pushd that is not ported
;; UNPORTED: do_build: after a cd or pushd that is not ported
;; UNPORTED: do_build: after a cd or pushd that is not ported
;; UNPORTED: do_build: after a cd or pushd that is not ported
;; UNPORTED: do_install: $scaffolding_go_gopath
{:name "traefik"
 :origin "karate"
 :version "1.7.7"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "a modern reverse proxy"
 :upstream_url "https://traefik.io"
 :build_deps ["karate/node6" "karate/sed" "karate/yarn"]
 :scaffolding "karate/scaffolding-go"
 :bin_dirs ["bin"]
 :svc {:user "root" :group "root"}
 :exports {"web_port" "web.port" "web_host" "web.host" "web_enabled" "web.enable"}
 :download (fn [b]
          (b:run ["go" "get" "-d" "github.com/containous/traefik"])
          ;; UNPORTED ($scaffolding_go_gopath):
          ;;   pushd "${scaffolding_go_gopath:?}/src/github.com/containous/traefik"
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   git reset --hard "v${pkg_version}"
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   popd
          )
 :prepare (fn [b]
          ;; UNPORTED ($scaffolding_go_gopath):
          ;;   export PATH="${scaffolding_go_gopath:?}/bin:${PATH}"
          (b:env "VERSION" (.. "v" b.version))
          (b:env "CODENAME" "maroilles")
          (b:run ["go" "get" "github.com/jteeuwen/go-bindata"])
          (b:run ["go" "install" "github.com/jteeuwen/go-bindata/..."]))
 :build (fn [b]
          (var v-interpreter-new "")
          (var v-interpreter-old "")
          (var v-t "")
          (b:env "PATH" (.. (b:path_for "karate/node6") "/bin:" (or (b:getenv "PATH") "")))
          ;; UNPORTED ($scaffolding_go_gopath):
          ;;   pushd "${scaffolding_go_gopath:?}/src/github.com/containous/traefik"
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   pushd webui
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   yarn install
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   for t in node_modules/.bin/*; do
          ;;           local interpreter_old
          ;;           local interpreter_new
          ;;           interpreter_old=".*node"
          ;;           interpreter_new="$(pkg_path_for core/node6)/bin/node"
          ;;           t="$(readlink --canonicalize --no-newline "${t}")"
          ;;           sed -e "s#\#\!${interpreter_old}#\#\!${interpreter_new}#" -i "${t}"
          ;;         done
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   yarn run build
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   popd
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   bash script/generate
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   bash script/binary
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   popd
          )
 :install (fn [b]
          ;; UNPORTED ($scaffolding_go_gopath):
          ;;   cp "${scaffolding_go_gopath:?}/src/github.com/containous/traefik/dist/traefik" "${pkg_prefix}/bin"
          )}
