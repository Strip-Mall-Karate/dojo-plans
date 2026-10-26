;; storm, ported from its plan.sh.
{:name "storm"
 :origin "karate"
 :version "1.1.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "Open source distributed realtime computation system."
 :upstream_url "http://storm.apache.org/index.html"
 :source {:url "http://apache.mediamirrors.org/storm/apache-storm-1.1.2/apache-storm-1.1.2.tar.gz" :sha256 "823dad47e2941e126caf1186047da1c6058076115589905033e87987db7bfa27" :dirname "apache-storm-1.1.2"}
 :deps ["karate/jre8" "karate/python" "karate/bash"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :binds {"zookeeper" [] "storm" []}
 :build (fn [b]
          nil)
 :install (fn [b]
          (b:copy (b:join b.src "README.markdown") (.. b.prefix "/README.md"))
          (b:chmod (.. b.prefix "/README.md") "644")
          (b:copy (b:join b.src "LICENSE") (.. b.prefix "/LICENSE.txt"))
          (b:chmod (.. b.prefix "/LICENSE.txt") "644")
          (b:copy (b:join b.src "NOTICE") (.. b.prefix "/NOTICE.txt"))
          (b:chmod (.. b.prefix "/NOTICE.txt") "644")
          (b:copy (b:join b.src "bin") (b:join b.prefix (: (b:join b.src "bin") :match "[^/]+$")))
          (b:copy (b:join b.src "lib") (b:join b.prefix (: (b:join b.src "lib") :match "[^/]+$")))
          (b:copy (b:join b.src "log4j2") (b:join b.prefix (: (b:join b.src "log4j2") :match "[^/]+$")))
          (b:copy (b:join b.src "public") (b:join b.prefix (: (b:join b.src "public") :match "[^/]+$"))))}
