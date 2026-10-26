;; kafka, ported from its plan.sh.
{:name "kafka"
 :origin "karate"
 :version "0.10.2.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "A distributed streaming platform"
 :upstream_url "https://kafka.apache.org/"
 :source {:url "http://mirrors.gigenet.com/apache/kafka/0.10.2.2/kafka_2.11-0.10.2.2.tgz" :sha256 "60f587ed8d1ee6e8e8057f13da6eee472f95c8d2ea691f6aab74edb842dc9950" :dirname "kafka_2.11-0.10.2.2"}
 :deps ["karate/bash-static" "karate/coreutils" "karate/jre8"]
 :bin_dirs ["bin"]
 :binds {"zookeeper" ["port"]}
 :build (fn [b]
          (b:fix_interpreter (b:glob (b:join b.src "bin") "*") "karate/bash-static" "bin/bash"))
 :install (fn [b]
          (b:copy (b:join b.src "libs") (b:join b.prefix (: (b:join b.src "libs") :match "[^/]+$")))
          (b:copy (b:join b.src "bin") (b:join b.prefix (: (b:join b.src "bin") :match "[^/]+$"))))}
