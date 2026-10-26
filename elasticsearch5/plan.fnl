;; elasticsearch5, ported from its plan.sh.
;; Built from the elasticsearch plan, with its own changes.
{:name "elasticsearch5"
 :origin "karate"
 :version "5.6.14"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Revised BSD"]
 :description "Open Source, Distributed, RESTful Search Engine"
 :upstream_url "https://elastic.co"
 :source {:url "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.6.14.tar.gz" :sha256 "6c8b46498186bb2f4183660d8653375fc38bddd043302ddb20c516b42ab0125e" :dirname "elasticsearch-5.6.14"}
 :deps ["karate/coreutils-static" "karate/busybox-static" "karate/glibc" "karate/zlib" "karate/corretto8" "karate/wget"]
 :build_deps ["karate/patchelf"]
 :bin_dirs ["es/bin"]
 :lib_dirs ["es/lib"]
 :exports {"http-port" "network.port" "transport-port" "transport.port"}
 :exposes ["http-port" "transport-port"]
 :binds_optional {"elasticsearch" ["http-port" "transport-port"]}
 :build (fn [b]
          nil)
 :install (fn [b]
          (b:copy (b:join b.src "README.textile") (.. b.prefix "/README.textile"))
          (b:chmod (.. b.prefix "/README.textile") "644")
          (b:copy (b:join b.src "LICENSE.txt") (.. b.prefix "/LICENSE.txt"))
          (b:chmod (.. b.prefix "/LICENSE.txt") "644")
          (b:copy (b:join b.src "NOTICE.txt") (.. b.prefix "/NOTICE.txt"))
          (b:chmod (.. b.prefix "/NOTICE.txt") "644")
          (b:mkdir (.. b.prefix "/es"))
          (each [_ p (ipairs (b:glob b.src "*"))] (b:copy p (b:join (.. b.prefix "/es") (: p :match "[^/]+$"))))
          (each [_ p (ipairs (b:glob (.. b.prefix "/es/bin") "*.bat"))] (b:remove p))
          (each [_ p (ipairs (b:glob (.. b.prefix "/es/bin") "*.exe"))] (b:remove p)))
 :strip (fn [b]
          nil)}
