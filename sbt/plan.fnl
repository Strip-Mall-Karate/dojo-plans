;; sbt, ported from its plan.sh.
{:name "sbt"
 :origin "karate"
 :version "1.2.8"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "A build tool for Scala, Java, and more"
 :upstream_url "https://www.scala-sbt.org"
 :source {:url "https://github.com/sbt/sbt/releases/download/v1.2.8/sbt-1.2.8.tgz" :sha256 "9bb9212541176d6fcce7bd12e4cf8a9c9649f5b63f88b3aff474e0b02c7cfe58"}
 :deps ["karate/coreutils" "karate/jre8" "karate/bash" "karate/sed" "karate/grep"]
 :bin_dirs ["bin"]
 :prepare (fn [b]
          (var v-java-home (b:path_for "karate/jre8"))
          (b:env "JAVA_HOME" v-java-home))
 :build (fn [b]
          nil)
 :install (fn [b]
          (b:mkdir (.. b.prefix "/share"))
          (if (b:exists (.. b.prefix "/share"))
            (b:copy (.. b.cache "/sbt") (b:join (.. b.prefix "/share") (: (.. b.cache "/sbt") :match "[^/]+$")))
            (b:copy (.. b.cache "/sbt") (.. b.prefix "/share")))
          (b:symlink (.. b.prefix "/share/sbt/bin/sbt") (b:join (.. b.prefix "/bin/") (: (.. b.prefix "/share/sbt/bin/sbt") :match "[^/]+$")))
          (b:fix_interpreter [(.. b.prefix "/bin/sbt")] "karate/coreutils" "bin/env"))}
