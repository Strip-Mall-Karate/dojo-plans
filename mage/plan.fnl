;; mage, ported from its plan.sh.
;; The source project's plan fetched mage with `go get` and reset it to the
;; v1.7.1 tag. This is that tag's archive, pinned.
{:name :mage
 :origin :karate
 :version :1.7.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0]
 :description "Mage is a make/rake-like build tool using Go. You write plain-old go functions, and Mage automatically uses them as Makefile-like runnable targets."
 :upstream_url "https://magefile.org/"
 :source {:url "https://github.com/magefile/mage/archive/v1.7.1.tar.gz"
          :sha256 :1ee01601ba5728b5a0cda61f5e3bcdd227d9ae202a49acbcce69583e2ca6cc9a
          :filename :mage-v1.7.1.tar.gz}
 :scaffolding :karate/scaffolding-go
 :bin_dirs [:bin]
 :build (fn [b]
          ;; mage's bootstrap (`go run bootstrap.go`) runs its Install target, which
          ;; stamps the commit and tag git reports. The archive has no git history, so
          ;; this is that target's build with v1.7.1's commit and tag.
          (b.scaffolding.env b)
          (let [stamp (b:capture [:date :-u "+%Y-%m-%dT%H:%M:%SZ"])
                flags (.. "-X \"github.com/magefile/mage/mage.timestamp=" stamp
                          "\" "
                          "-X \"github.com/magefile/mage/mage.commitHash=11d1591\" "
                          "-X \"github.com/magefile/mage/mage.gitTag=v1.7.1\"")]
            (b:run [:go
                    :build
                    :-o
                    (b:join (b.scaffolding.gopath b) :bin/mage)
                    (.. :-ldflags= flags)
                    :github.com/magefile/mage]
                   {:cwd (b.scaffolding.pkg_path b)})))
 :install (fn [b]
            (b:copy (b:join (b.scaffolding.gopath b) :bin/mage)
                    (b:join b.prefix :bin/mage)))}
