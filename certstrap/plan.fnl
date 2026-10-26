;; certstrap, ported from its plan.sh.
;; The source project's plan fetched certstrap with `go get` and reset it to the
;; v1.1.1 tag. This is that tag's archive, pinned; its imports name the
;; dependencies it keeps in Godeps/_workspace. It builds for the target's
;; architecture where the plan named amd64. The plan also built godep at its
;; newest commit, which nothing ran; that is left out.
{:name "certstrap"
 :origin "karate"
 :version "v1.1.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "A simple certificate manager written in Go, to bootstrap your own certificate authority and public key infrastructure. Adapted from etcd-ca."
 :upstream_url "https://github.com/square/certstrap"
 :source {:url "https://github.com/square/certstrap/archive/v1.1.1.tar.gz" :sha256 "412ba90a4a48d535682f3c7529191cd30cd7a731e57065dcf4242155cec49d5e" :filename "certstrap-v1.1.1.tar.gz"}
 :scaffolding "karate/scaffolding-go"
 :bin_dirs ["bin"]
 :build (fn [b]
          (b.scaffolding.env b)
          (b:log "building certstrap")
          (b:run ["go" "build" "-o" "bin/certstrap" "github.com/square/certstrap"]
                 {:cwd (b.scaffolding.pkg_path b) :env {"GOARCH" (b.scaffolding.goarch b) "GOOS" "linux"}}))
 :install (fn [b]
            (b:log "copying certstrap binary")
            (b:copy (b:join (b.scaffolding.pkg_path b) "bin/certstrap") (b:join b.prefix "bin/certstrap")))}
