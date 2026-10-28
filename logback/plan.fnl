;; logback, ported from its plan.sh.
{:name :logback
 :origin :karate
 :version :1.1.8
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:EPL-1.0]
 :description "The reliable, generic, fast and flexible logging framework for Java."
 :upstream_url "http://logback.qos.ch"
 :source {:url "http://logback.qos.ch/dist/logback-1.1.8.tar.gz"
          :sha256 :c365d6fb6e811b78e64610abc61f04a6de79884d87c592af8593d16a48194610}
 :lib_dirs [:lib]
 :build (fn [_b]
          nil)
 :install (fn [b]
            (b:copy (.. b.cache "/" b.name "-" b.version :/logback-core-
                        b.version :.jar)
                    (b:join (.. b.prefix :/lib/)
                            (: (.. b.cache "/" b.name "-" b.version
                                   :/logback-core- b.version :.jar)
                               :match "[^/]+$")))
            (b:chmod (b:join (.. b.prefix :/lib/)
                             (: (.. b.cache "/" b.name "-" b.version
                                    :/logback-core- b.version :.jar)
                                :match "[^/]+$")) :755)
            (b:copy (.. b.cache "/" b.name "-" b.version :/logback-core-
                        b.version :-sources.jar)
                    (b:join (.. b.prefix :/lib/)
                            (: (.. b.cache "/" b.name "-" b.version
                                   :/logback-core- b.version :-sources.jar)
                               :match "[^/]+$")))
            (b:chmod (b:join (.. b.prefix :/lib/)
                             (: (.. b.cache "/" b.name "-" b.version
                                    :/logback-core- b.version :-sources.jar)
                                :match "[^/]+$")) :755)
            (b:copy (.. b.cache "/" b.name "-" b.version :/logback-access-
                        b.version :.jar)
                    (b:join (.. b.prefix :/lib/)
                            (: (.. b.cache "/" b.name "-" b.version
                                   :/logback-access- b.version :.jar)
                               :match "[^/]+$")))
            (b:chmod (b:join (.. b.prefix :/lib/)
                             (: (.. b.cache "/" b.name "-" b.version
                                    :/logback-access- b.version :.jar)
                                :match "[^/]+$")) :755)
            (b:copy (.. b.cache "/" b.name "-" b.version :/logback-access-
                        b.version :-sources.jar)
                    (b:join (.. b.prefix :/lib/)
                            (: (.. b.cache "/" b.name "-" b.version
                                   :/logback-access- b.version :-sources.jar)
                               :match "[^/]+$")))
            (b:chmod (b:join (.. b.prefix :/lib/)
                             (: (.. b.cache "/" b.name "-" b.version
                                    :/logback-access- b.version :-sources.jar)
                                :match "[^/]+$")) :755)
            (b:copy (.. b.cache "/" b.name "-" b.version :/logback-classic-
                        b.version :.jar)
                    (b:join (.. b.prefix :/lib/)
                            (: (.. b.cache "/" b.name "-" b.version
                                   :/logback-classic- b.version :.jar)
                               :match "[^/]+$")))
            (b:chmod (b:join (.. b.prefix :/lib/)
                             (: (.. b.cache "/" b.name "-" b.version
                                    :/logback-classic- b.version :.jar)
                                :match "[^/]+$")) :755)
            (b:copy (.. b.cache "/" b.name "-" b.version :/logback-classic-
                        b.version :-sources.jar)
                    (b:join (.. b.prefix :/lib/)
                            (: (.. b.cache "/" b.name "-" b.version
                                   :/logback-classic- b.version :-sources.jar)
                               :match "[^/]+$")))
            (b:chmod (b:join (.. b.prefix :/lib/)
                             (: (.. b.cache "/" b.name "-" b.version
                                    :/logback-classic- b.version :-sources.jar)
                                :match "[^/]+$")) :755))}
