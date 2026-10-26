;; helm, ported from its plan.sh.
;; UNPORTED: do_download: pipeline or list
;; UNPORTED: do_download: $scaffolding_go_pkg_path
;; UNPORTED: do_download: after a cd or pushd that is not ported
;; UNPORTED: do_download: after a cd or pushd that is not ported
;; UNPORTED: do_build: $scaffolding_go_pkg_path
;; UNPORTED: do_build: after a cd or pushd that is not ported
;; UNPORTED: do_build: after a cd or pushd that is not ported
;; UNPORTED: do_build: after a cd or pushd that is not ported
;; UNPORTED: do_install: $scaffolding_go_pkg_path
{:name "helm"
 :origin "karate"
 :version "2.7.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "Helm is a tool for managing Kubernetes charts"
 :upstream_url "https://k8s.io/helm"
 :build_deps ["karate/which" "karate/coreutils" "karate/mercurial"]
 :scaffolding "karate/scaffolding-go"
 :bin_dirs ["bin"]
 :download (fn [b]
          (b:log "go get -d k8s.io/helm")
          ;; UNPORTED (pipeline or list):
          ;;   go get -d $go_pkg 2>&1 | grep -q "no Go files"
          ;; UNPORTED ($scaffolding_go_pkg_path):
          ;;   pushd "$scaffolding_go_pkg_path"
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   git reset --hard v$pkg_version
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   popd
          )
 :prepare (fn [b]
          (b:log "mkdir -p $GOPATH/bin; export PATH=$GOPATH/bin:$PATH")
          (b:mkdir (.. (or (b:getenv "GOPATH") "") "/bin"))
          (b:env "PATH" (.. (or (b:getenv "GOPATH") "") "/bin:" (or (b:getenv "PATH") ""))))
 :build (fn [b]
          (b:log (.. "ln -fs \"" (b:capture ["which" "env"]) "\" /usr/bin/env"))
          (b:remove "/usr/bin/env")
          (b:symlink (b:capture ["which" "env"]) "/usr/bin/env")
          ;; UNPORTED ($scaffolding_go_pkg_path):
          ;;   pushd "$scaffolding_go_pkg_path"
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   build_line "make bootstrap build"
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   make bootstrap build
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   popd
          )
 :install (fn [b]
          (b:log "copying Helm binary")
          ;; UNPORTED ($scaffolding_go_pkg_path):
          ;;   cp -f "${scaffolding_go_pkg_path:?}/bin/helm" "$pkg_prefix/bin"
          )}
