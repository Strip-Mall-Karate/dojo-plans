;; zookeeper, ported from its plan.sh.
{:name "zookeeper"
 :origin "karate"
 :version "3.4.13"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "The Apache ZooKeeper system for distributed coordination is a high-performance service for building distributed applications."
 :upstream_url "https://zookeeper.apache.org"
 :source {:url "http://apache.mirrors.ionfish.org/zookeeper/zookeeper-3.4.13/zookeeper-3.4.13.tar.gz" :sha256 "7ced798e41d2027784b8fd55c908605ad5bd94a742d5dab2506be8f94770594d"}
 :deps ["karate/bash-static" "karate/coreutils" "karate/jre8"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :exports {"port" "zookeeper.clientPort"}
 :build (fn [b]
          nil)
 :install (fn [b]
          (b:fix_interpreter (b:glob (b:join b.src "bin") "*") "karate/coreutils" "bin/env")
          (b:copy (b:join b.src "bin") (b:join b.prefix (: (b:join b.src "bin") :match "[^/]+$")))
          (b:copy (b:join b.src "lib") (b:join b.prefix (: (b:join b.src "lib") :match "[^/]+$")))
          (b:copy (b:join b.src (.. "dist-maven/" (.. b.name "-" b.version) ".jar")) (b:join b.prefix (: (b:join b.src (.. "dist-maven/" (.. b.name "-" b.version) ".jar")) :match "[^/]+$"))))}
