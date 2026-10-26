;; logstash2, ported from its plan.sh.
{:name "logstash2"
 :origin "karate"
 :version "2.4.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "Logstash is an open source, server-side data processing pipeline that ingests data from a multitude of sources simultaneously, transforms it, and then sends it to your favorite 'stash.'"
 :upstream_url "https://www.elastic.co/products/logstash"
 :source {:url "https://download.elastic.co/logstash/logstash/logstash-2.4.1.tar.gz" :sha256 "957647af07e54c7d18c6e3b543030edae461d447d27412ebb7637cd7eb109f4f" :dirname "logstash-2.4.1"}
 :deps ["karate/coreutils" "karate/jre8" "karate/jruby1"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :build (fn [b]
          nil)
 :install (fn [b]
          (b:mkdir b.prefix)
          (each [_ p (ipairs (b:glob b.src "*"))] (b:copy p (b:join b.prefix (: p :match "[^/]+$"))))
          (b:remove (.. b.prefix "/vendor/jruby"))
          (each [_ p (ipairs (b:glob (.. b.prefix "/bin") "*.bat"))] (b:remove p)))}
