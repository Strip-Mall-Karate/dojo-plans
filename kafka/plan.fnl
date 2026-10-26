;; kafka, ported from its plan.sh.
;; kafka 3.9.2, the latest release of the 3.x series on 2026-10-26 (4.x dropped ZooKeeper and needs Java 17): 0.10.2.2's source no longer downloads.
{:name "kafka"
 :origin "karate"
 :version "3.9.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "A distributed streaming platform"
 :upstream_url "https://kafka.apache.org/"
 :source {:url "https://archive.apache.org/dist/kafka/3.9.2/kafka_2.13-3.9.2.tgz" :sha256 "d5d951c22484f9a0908b05563bc80a042de9779df1e06a89f77d27ceb5f68323" :dirname "kafka_2.13-3.9.2"}
 :deps ["karate/bash-static" "karate/coreutils" "karate/corretto8"]
 :bin_dirs ["bin"]
 :binds {"zookeeper" ["port"]}
 :build (fn [b]
          (b:fix_interpreter (b:glob (b:join b.src "bin") "*") "karate/bash-static" "bin/bash"))
 :install (fn [b]
          (b:copy (b:join b.src "libs") (b:join b.prefix (: (b:join b.src "libs") :match "[^/]+$")))
          (b:copy (b:join b.src "bin") (b:join b.prefix (: (b:join b.src "bin") :match "[^/]+$"))))}
