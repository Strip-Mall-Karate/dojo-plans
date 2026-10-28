;; crate, ported from its plan.sh.
{:name :crate
 :origin :karate
 :version :1.1.2
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0]
 :description "CrateDB is an open source SQL database with a ground-breaking distributed design."
 :upstream_url "https://crate.io"
 :source {:url "https://cdn.crate.io/downloads/releases/crate-1.1.2.tar.gz"
          :sha256 :8f22b6531b3d1c8602a880779bbe09e5295ef0959a30aff0986575835aadc937}
 :deps [:karate/corretto8 :karate/curl]
 :build_deps [:karate/gnupg]
 :bin_dirs [:crate/bin]
 :lib_dirs [:crate/lib]
 :exports {:http :http.port
           :transport :transport.tcp.port
           :postgres :psql.port}
 :exposes [:http :transport :postgres]
 :download (fn [b]
             (b.default.download b)
             (b:download (.. "https://cdn.crate.io/downloads/releases/" b.name
                             "-" b.version :.tar.gz.asc)
                         :4e6007a35b99c0da75356cb6cd7aeafd7d380e1a5f5fa26b79a0dfa0a9898924
                         (.. b.name "-" b.version :.tar.gz.asc)))
 :verify (fn [b]
           (b.default.verify b)
           (b:log (.. "Verifying crate-" b.version ".tar.gz signature"))
           (local v-gnupghome (b:capture [:mktemp :-d :-p b.cache]))
           (b:run [:gpg
                   :--keyserver
                   :ha.pool.sks-keyservers.net
                   :--recv-keys
                   :90C23FC6585BC0717F8FBFC37FAAE51A06F6EAEB])
           (b:run [:gpg
                   :--batch
                   :--verify
                   (.. b.cache "/" b.name "-" b.version :.tar.gz.asc)
                   (.. b.cache "/" b.name "-" b.version :.tar.gz)])
           (b:remove v-gnupghome)
           (b:log (.. "Signature verified for " b.name "-" b.version :.tar.gz)))
 :build (fn [_b]
          nil)
 :install (fn [b]
            (b:copy (b:join (.. b.cache "/" b.name "-" b.version) :README.rst)
                    (.. b.prefix :/README.rst))
            (b:chmod (.. b.prefix :/README.rst) :644)
            (b:copy (b:join (.. b.cache "/" b.name "-" b.version) :LICENSE.txt)
                    (.. b.prefix :/LICENSE.txt))
            (b:chmod (.. b.prefix :/LICENSE.txt) :644)
            (b:copy (b:join (.. b.cache "/" b.name "-" b.version) :NOTICE)
                    (.. b.prefix :/NOTICE))
            (b:chmod (.. b.prefix :/NOTICE) :644)
            (b:copy (b:join (.. b.cache "/" b.name "-" b.version) :CHANGES.txt)
                    (.. b.prefix :/CHANGES.txt))
            (b:chmod (.. b.prefix :/CHANGES.txt) :644)
            (b:mkdir (.. b.prefix :/crate))
            (b:copy (b:join (.. b.cache "/" b.name "-" b.version) :bin)
                    (b:join (.. b.prefix :/crate)
                            (: (b:join (.. b.cache "/" b.name "-" b.version)
                                       :bin)
                               :match "[^/]+$")))
            (b:copy (b:join (.. b.cache "/" b.name "-" b.version) :lib)
                    (b:join (.. b.prefix :/crate)
                            (: (b:join (.. b.cache "/" b.name "-" b.version)
                                       :lib)
                               :match "[^/]+$")))
            (b:copy (b:join (.. b.cache "/" b.name "-" b.version) :plugins)
                    (b:join (.. b.prefix :/crate)
                            (: (b:join (.. b.cache "/" b.name "-" b.version)
                                       :plugins)
                               :match "[^/]+$")))
            (each [_ p (ipairs (b:glob (.. b.prefix :/crate/bin) :*.bat))]
              (b:remove p)))
 :strip (fn [_b]
          nil)}
