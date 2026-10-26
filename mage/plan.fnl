;; mage, ported from its plan.sh.
;; UNPORTED: do_download: $scaffolding_go_pkg_path
;; UNPORTED: do_download: after a cd or pushd that is not ported
;; UNPORTED: do_download: after a cd or pushd that is not ported
;; UNPORTED: do_build: $scaffolding_go_pkg_path
;; UNPORTED: do_build: after a cd or pushd that is not ported
;; UNPORTED: do_build: after a cd or pushd that is not ported
{:name "mage"
 :origin "karate"
 :version "1.7.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "Mage is a make/rake-like build tool using Go. You write plain-old go functions, and Mage automatically uses them as Makefile-like runnable targets."
 :upstream_url "https://magefile.org/"
 :scaffolding "karate/scaffolding-go"
 :bin_dirs ["bin"]
 :download (fn [b]
          (b:run ["scaffolding_go_download"])
          ;; UNPORTED ($scaffolding_go_pkg_path):
          ;;   pushd "${scaffolding_go_pkg_path}" > /dev/null
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   git reset --hard "v${pkg_version}"
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   popd > /dev/null
          )
 :build (fn [b]
          ;; UNPORTED ($scaffolding_go_pkg_path):
          ;;   pushd "${scaffolding_go_pkg_path}" > /dev/null
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   go run bootstrap.go
          ;; UNPORTED (after a cd or pushd that is not ported):
          ;;   popd > /dev/null
          )
 :install (fn [b]
          (if (b:exists (.. b.prefix "/bin/mage"))
            (b:copy (.. (or (b:getenv "GOPATH") "") "/bin/mage") (b:join (.. b.prefix "/bin/mage") (: (.. (or (b:getenv "GOPATH") "") "/bin/mage") :match "[^/]+$")))
            (b:copy (.. (or (b:getenv "GOPATH") "") "/bin/mage") (.. b.prefix "/bin/mage"))))}
