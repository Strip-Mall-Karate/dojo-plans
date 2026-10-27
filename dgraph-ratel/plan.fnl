;; dgraph-ratel, ported from its plan.sh.
{:name :dgraph-ratel
 :origin :karate
 :version :1.0.6
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0]
 :description "Distributed transactional graph database written in go"
 :upstream_url "https://dgraph.io"
 :source {:url "https://github.com/dgraph-io/dgraph/releases/download/v1.0.6/dgraph-linux-amd64.tar.gz"
          :sha256 :616a3dc22973c48bbe57036dde5ea91055761f565a22bfbe20b6079fd16a9156}
 :deps [:karate/glibc]
 :build_deps [:karate/patchelf]
 :bin_dirs [:bin]
 :build (fn [b]
          nil)
 :install (fn [b]
            (if (b:exists (.. b.prefix :/bin/ b.name))
                (b:copy (.. b.cache "/" b.name)
                        (b:join (.. b.prefix :/bin/ b.name)
                                (: (.. b.cache "/" b.name) :match "[^/]+$")))
                (b:copy (.. b.cache "/" b.name) (.. b.prefix :/bin/ b.name)))
            (b:run [:patchelf
                    :--interpreter
                    (.. (b:path_for :glibc) :/lib/ld-linux-x86-64.so.2)
                    (.. b.prefix :/bin/ b.name)]))}
