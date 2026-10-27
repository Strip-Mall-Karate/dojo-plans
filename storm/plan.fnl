;; storm, ported from its plan.sh.
;; storm 3.1.0, the latest release on 2026-10-26: 1.1.2's source no longer downloads.
{:name :storm
 :origin :karate
 :version :3.1.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0]
 :description "Open source distributed realtime computation system."
 :upstream_url "http://storm.apache.org/index.html"
 :source {:url "https://dlcdn.apache.org/storm/apache-storm-3.1.0/apache-storm-3.1.0.tar.gz"
          :sha256 :4fd7853462cb591e94dc594f95effe8e107842d8d6041482cc0b3e01ece5198c
          :dirname :apache-storm-3.1.0}
 :deps [:karate/corretto8 :karate/python :karate/bash]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :binds {:zookeeper [] :storm []}
 :build (fn [b]
          nil)
 :install (fn [b]
            (b:copy (b:join b.src :README.markdown) (.. b.prefix :/README.md))
            (b:chmod (.. b.prefix :/README.md) :644)
            (b:copy (b:join b.src :LICENSE) (.. b.prefix :/LICENSE.txt))
            (b:chmod (.. b.prefix :/LICENSE.txt) :644)
            (b:copy (b:join b.src :NOTICE) (.. b.prefix :/NOTICE.txt))
            (b:chmod (.. b.prefix :/NOTICE.txt) :644)
            (b:copy (b:join b.src :bin)
                    (b:join b.prefix (: (b:join b.src :bin) :match "[^/]+$")))
            (b:copy (b:join b.src :lib)
                    (b:join b.prefix (: (b:join b.src :lib) :match "[^/]+$")))
            (b:copy (b:join b.src :log4j2)
                    (b:join b.prefix (: (b:join b.src :log4j2) :match "[^/]+$")))
            (b:copy (b:join b.src :public)
                    (b:join b.prefix (: (b:join b.src :public) :match "[^/]+$"))))}
