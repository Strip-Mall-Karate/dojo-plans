;; grpcurl, ported from its plan.sh.
;; UNPORTED: do_download: $scaffolding_go_gopath
;; UNPORTED: do_download: after a cd or pushd that is not ported
;; UNPORTED: do_download: after a cd or pushd that is not ported
;; UNPORTED: do_build: $scaffolding_go_gopath
;; UNPORTED: do_build: after a cd or pushd that is not ported
;; UNPORTED: do_build: after a cd or pushd that is not ported
;; UNPORTED: do_install: $scaffolding_go_gopath
{:name "grpcurl"
 :origin "karate"
 :version "1.1.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "Like cURL, but for gRPC: Command-line tool for interacting with gRPC servers"
 :upstream_url "https://github.com/fullstorydev/grpcurl"
 :scaffolding "karate/scaffolding-go"
 :bin_dirs ["bin"]
 :download (fn [b]
          (b:run ["go" "get" "-d" "github.com/fullstorydev/grpcurl"])
          ;; UNPORTED ($scaffolding_go_gopath):
          ;;   pushd "${scaffolding_go_gopath:?}/src/$gopkg"
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   git reset --hard "v$pkg_version"
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   popd
          )
 :build (fn [b]
          ;; UNPORTED ($scaffolding_go_gopath):
          ;;   pushd "${scaffolding_go_gopath:?}/src/$gopkg"
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   make install
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   popd
          )
 :install (fn [b]
          ;; UNPORTED ($scaffolding_go_gopath):
          ;;   cp "${scaffolding_go_gopath:?}/bin/grpcurl" "${pkg_prefix}/bin/"
          )}
