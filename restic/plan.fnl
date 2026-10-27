;; restic, ported from its plan.sh.
{:name :restic
 :origin :karate
 :version :0.9.3
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:BSD-2-Clause]
 :description "Fast, secure, efficient backup program"
 :upstream_url "https://restic.net/"
 :source {:url "https://github.com/restic/restic/releases/download/v0.9.3/restic-0.9.3.tar.gz"
          :sha256 :b95a258099aee9a56e620ccebcecabc246ee7f8390e3937ccedadd609c6d2dd0}
 :build_deps [:karate/go]
 :bin_dirs [:bin]
 :build (fn [b]
          (b:run [:go
                  :build
                  :-mod=vendor
                  :-ldflags
                  "-s -w"
                  :-tags
                  :selfupdate
                  :-o
                  :restic_linux_amd64
                  :./cmd/restic]
                 {:env {:GOOS :linux :GOARCH :amd64 :CGO_ENABLED :0}}))
 :install (fn [b]
            (if (b:exists (.. b.prefix :/bin/restic))
                (b:copy (b:join b.src :restic_linux_amd64)
                        (b:join (.. b.prefix :/bin/restic)
                                (: (b:join b.src :restic_linux_amd64) :match
                                   "[^/]+$")))
                (b:copy (b:join b.src :restic_linux_amd64)
                        (.. b.prefix :/bin/restic))))}
