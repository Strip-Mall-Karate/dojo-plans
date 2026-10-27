;; spark, ported from its plan.sh.
{:name :spark
 :origin :karate
 :version :2.1.2
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0]
 :description "Apache Spark is a fast and general-purpose cluster computing system. It provides high-level APIs in Java, Scala, Python and R, and an optimized engine that supports general execution graphs."
 :upstream_url "https://spark.apache.org"
 :source {:url "https://archive.apache.org/dist/spark/spark-2.1.2/spark-2.1.2-bin-hadoop2.7.tgz"
          :sha256 :3e31164281326fe47210f5d7f07190935815060063f451f41f78b91beb8ecd55
          :dirname :spark-2.1.2-bin-hadoop2.7}
 :deps [:karate/bash :karate/corretto8 :karate/procps-ng]
 :bin_dirs [:bin :sbin]
 :lib_dirs [:jars]
 :exports {:port :port}
 :exposes [:port]
 :build (fn [b]
          nil)
 :install (fn [b]
            (b:copy (b:join b.src :sbin)
                    (b:join b.prefix (: (b:join b.src :sbin) :match "[^/]+$")))
            (b:copy (b:join b.src :bin)
                    (b:join b.prefix (: (b:join b.src :bin) :match "[^/]+$")))
            (b:copy (b:join b.src :jars)
                    (b:join b.prefix (: (b:join b.src :jars) :match "[^/]+$"))))}
