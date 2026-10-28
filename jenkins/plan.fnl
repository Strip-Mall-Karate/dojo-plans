;; jenkins, ported from its plan.sh.
{:name :jenkins
 :origin :karate
 :version :2.150.3
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "The leading open source automation server, Jenkins provides hundreds of plugins to support building, deploying and automating any project."
 :upstream_url "https://jenkins.io/"
 :source {:url "http://mirrors.jenkins.io/war-stable/2.150.3/jenkins.war"
          :sha256 :4fc2700a27a6ccc53da9d45cc8b2abd41951b361e562e1a1ead851bea61630fd}
 :deps [:karate/corretto8 :karate/curl]
 :svc {:user :root}
 :exports {:port :jenkins.http.port}
 :exposes [:port]
 :unpack (fn [_b]
           nil)
 :build (fn [_b]
          nil)
 :install (fn [b]
            (if (b:exists (.. b.prefix :/jenkins.war))
                (b:copy (.. b.cache :/jenkins.war)
                        (b:join (.. b.prefix :/jenkins.war)
                                (: (.. b.cache :/jenkins.war) :match "[^/]+$")))
                (b:copy (.. b.cache :/jenkins.war) (.. b.prefix :/jenkins.war))))}
