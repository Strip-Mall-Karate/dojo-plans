;; dep, ported from its plan.sh.
;; UNPORTED: do_download: $scaffolding_go_pkg_path
;; UNPORTED: do_download: after a cd or pushd that is not ported
;; UNPORTED: do_download: after a cd or pushd that is not ported
;; UNPORTED: do_build: $scaffolding_go_pkg_path
;; UNPORTED: do_build: after a cd or pushd that is not ported
;; UNPORTED: do_build: after a cd or pushd that is not ported
;; UNPORTED: do_install: $scaffolding_go_pkg_path
{:name "dep"
 :origin "karate"
 :version "0.5.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["BSD-3-Clause"]
 :description "Go dependency management tool"
 :upstream_url "https://github.com/golang/dep"
 :scaffolding "karate/scaffolding-go"
 :bin_dirs ["bin"]
 :download (fn [b]
          (b:run ["scaffolding_go_download"])
          ;; UNPORTED ($scaffolding_go_pkg_path):
          ;;   pushd "${scaffolding_go_pkg_path}" >/dev/null
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   git reset --hard "v${pkg_version}"
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   popd >/dev/null
          )
 :build (fn [b]
          ;; UNPORTED ($scaffolding_go_pkg_path):
          ;;   pushd "${scaffolding_go_pkg_path}/../.." >/dev/null
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   DEP_BUILD_ARCHS="amd64" DEP_BUILD_PLATFORMS="linux" bash -x hack/build-all.bash
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   popd >/dev/null
          )
 :install (fn [b]
          ;; UNPORTED ($scaffolding_go_pkg_path):
          ;;   cp "${scaffolding_go_pkg_path}/../../release/dep-linux-amd64" "${pkg_prefix}/bin/dep"
          )}
