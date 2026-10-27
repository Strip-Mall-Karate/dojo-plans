;; helm, ported from its plan.sh.
;; The source project's plan fetched helm with `go get` and reset it to the
;; v2.7.2 tag; `make bootstrap` then fetched glide and gox at their newest
;; commits, and glide the dependencies glide.lock names, at its commits. This is
;; the tag's archive, pinned, with glide v0.13.2 and gox v1.0.0, the releases
;; current at the fork date, pinned and built first so `make bootstrap` uses
;; them; glide still fetches the locked commits. The Makefile stamps the commit
;; and tag git reports, which an archive cannot; those are v2.7.2's. The plan
;; linked env to /usr/bin/env for the build, which neither target it runs uses.
;; The Makefile's shell is /bin/bash, which the source project's studio had;
;; here it is the bash this plan depends on.
{:name :helm
 :origin :karate
 :version :2.7.2
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0]
 :description "Helm is a tool for managing Kubernetes charts"
 :upstream_url "https://k8s.io/helm"
 :source {:url "https://github.com/helm/helm/archive/v2.7.2.tar.gz"
          :sha256 :aa5f7ec39b770e450f4aa28c63fa7212fcc4b7da623f0a1e6370afb083ee5fe1
          :filename :helm-v2.7.2.tar.gz}
 :build_deps [:karate/which :karate/coreutils :karate/mercurial :karate/bash]
 :scaffolding {:package :karate/scaffolding-go
               :settings {:import_path :k8s.io/helm}}
 :bin_dirs [:bin]
 :download (fn [b]
             (b.default.download b)
             (b:download "https://github.com/Masterminds/glide/archive/v0.13.2.tar.gz"
                         :0886851af2437b161d47b279a32bef426577e7bec3f5acdadebe34549aae8270
                         :glide-v0.13.2.tar.gz)
             (b:download "https://github.com/mitchellh/gox/archive/v1.0.0.tar.gz"
                         :53a31a6d98b2ace1c03c36aed7135935b6c7fa10cfa4e850ca2a8b3f272b57b3
                         :gox-v1.0.0.tar.gz))
 :prepare (fn [b]
            ;; glide and gox, which vendor what they need, built into $GOPATH/bin.
            (b.scaffolding.env b)
            (each [_ [import archive] (ipairs [[:github.com/Masterminds/glide
                                                :glide-v0.13.2.tar.gz]
                                               [:github.com/mitchellh/gox
                                                :gox-v1.0.0.tar.gz]])]
              (let [dir (b:join (b.scaffolding.gopath b) :src import)]
                (b:remove dir)
                (b:mkdir dir)
                (b:run [:tar
                        :xf
                        (b:join b.cache archive)
                        :--strip-components=1
                        :--no-same-owner] {:cwd dir})
                (b:run [:go :install import] {:cwd dir}))))
 :build (fn [b]
          (b.scaffolding.env b)
          (b:log "make bootstrap build")
          (b:run [:make
                  :bootstrap
                  :build
                  :GIT_COMMIT=8478fb4fc723885b155c924d1c8c410b7a9444e6
                  :GIT_SHA=8478fb4
                  :GIT_TAG=v2.7.2
                  :GIT_DIRTY=clean
                  (.. :SHELL= (b:path_for :karate/bash) :/bin/bash)]
                 {:cwd (b.scaffolding.pkg_path b)}))
 :install (fn [b]
            (b:log "copying Helm binary")
            (b:copy (b:join (b.scaffolding.pkg_path b) :bin/helm)
                    (b:join b.prefix :bin/helm)))}
