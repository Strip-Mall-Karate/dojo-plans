;; logstash, ported from its plan.sh.
{:name "logstash"
 :origin "karate"
 :version "6.4.3"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "Logstash is an open source, server-side data processing pipeline that ingests data from a multitude of sources simultaneously, transforms it, and then sends it to your favorite 'stash.'"
 :upstream_url "https://github.com/elastic/logstash"
 :source {:url "https://artifacts.elastic.co/downloads/logstash/logstash-6.4.3.tar.gz" :sha256 "72dcd1cf21e55cd44503ca7c452aaaa88286564ba1450d5d05941f88e2699cc3"}
 :deps ["karate/bash" "karate/corretto8" "karate/coreutils"]
 :build_deps ["karate/bash"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :build (fn [b]
          nil)
 :install (fn [b]
          (b:mkdir b.prefix)
          (each [_ p (ipairs (b:glob b.src "*"))] (b:copy p (b:join b.prefix (: p :match "[^/]+$"))))
          (b:mkdir (.. b.prefix "/data/queue"))
          (b:chmod (.. b.prefix "/data") "0777")
          (b:chmod (.. b.prefix "/data/queue") "0777")
          (if (b:exists (.. b.prefix "/settings"))
            (b:move (.. b.prefix "/config") (b:join (.. b.prefix "/settings") (: (.. b.prefix "/config") :match "[^/]+$")))
            (b:move (.. b.prefix "/config") (.. b.prefix "/settings")))
          (b:run ["find" (.. b.prefix "/vendor/jruby/lib/jni/") "-mindepth" "1" "-maxdepth" "1" "-type" "d" "-not" "-name" "x86_64-Linux" "-exec" "rm" "-rf" "{}" ";"])
          (b:fix_interpreter (b:glob (.. b.prefix "/bin") "*") "karate/bash" "bin/sh")
          (b:fix_interpreter (b:glob (.. b.prefix "/vendor/jruby/bin") "*") "karate/coreutils" "bin/env")
          (b:copy (.. b.plan_dir "/log4j2.properties") (b:join (.. b.prefix "/settings/") (: (.. b.plan_dir "/log4j2.properties") :match "[^/]+$"))))}
