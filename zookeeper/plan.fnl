;; zookeeper, ported from its plan.sh.
;; zookeeper 3.9.6, the latest release on 2026-10-26: 3.4.13's source no longer downloads.
{:name :zookeeper
 :origin :karate
 :version :3.9.6
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0]
 :description "The Apache ZooKeeper system for distributed coordination is a high-performance service for building distributed applications."
 :upstream_url "https://zookeeper.apache.org"
 :source {:url "https://dlcdn.apache.org/zookeeper/zookeeper-3.9.6/apache-zookeeper-3.9.6-bin.tar.gz"
          :sha256 :6034c9b7b92e60b28ac1f36639f704af98f6d09e74b081664534d3004621d176
          :filename :apache-zookeeper-3.9.6-bin.tar.gz
          :dirname :apache-zookeeper-3.9.6-bin}
 :deps [:karate/bash-static :karate/coreutils :karate/corretto8]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :exports {:port :zookeeper.clientPort}
 :build (fn [_b]
          nil)
 :install (fn [b]
            (b:fix_interpreter (b:glob (b:join b.src :bin) "*")
                               :karate/coreutils :bin/env)
            (b:copy (b:join b.src :bin)
                    (b:join b.prefix (: (b:join b.src :bin) :match "[^/]+$")))
            (b:copy (b:join b.src :lib)
                    (b:join b.prefix (: (b:join b.src :lib) :match "[^/]+$")))
            (b:copy (b:join b.src (.. :lib/ b.name "-" b.version :.jar))
                    (b:join b.prefix
                            (: (b:join b.src
                                       (.. :lib/ b.name "-" b.version :.jar))
                               :match "[^/]+$"))))}
