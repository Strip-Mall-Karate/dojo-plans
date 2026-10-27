;; tomcat7, ported from its plan.sh.
{:name :tomcat7
 :origin :karate
 :version :7.0.73
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0]
 :description "The Apache Tomcat software is an open source implementation of the Java Servlet, JavaServer Pages, Java Expression Language and Java WebSocket technologies."
 :upstream_url "http://tomcat.apache.org/"
 :source {:url "http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.73/bin/apache-tomcat-7.0.73.tar.gz"
          :sha256 :0e814d6ad7d5b90e29c79887137420d3bc413540f9faa60d98f11e6c8a8fea85}
 :deps [:karate/coreutils]
 :exports {:port :server.port}
 :exposes [:port]
 :unpack (fn [b]
           (var v-source-dir "")
           (var v-unpack-file "")
           (set v-source-dir (.. b.cache "/" b.name "-" b.version))
           (set v-unpack-file (.. b.cache :/apache-tomcat-7.0.73.tar.gz))
           (b:mkdir v-source-dir)
           (b:run [:tar :xz :--strip-components=1 :-f v-unpack-file]
                  {:cwd v-source-dir}))
 :build (fn [b]
          nil)
 :install (fn [b]
            (b:log "Performing install")
            (b:mkdir (.. b.prefix :/tc))
            (each [_ p (ipairs (b:glob b.src "*"))]
              (b:copy p (b:join (.. b.prefix :/tc) (: p :match "[^/]+$"))))
            (b:run [:find
                    (.. b.prefix :/tc)
                    :-type
                    :d
                    :-exec
                    :chmod
                    :-v
                    :755
                    "{}"
                    "+"])
            (b:run [:find
                    (.. b.prefix :/tc)
                    :-type
                    :f
                    :-exec
                    :chmod
                    :-v
                    :644
                    "{}"
                    "+"])
            (b:run [:find
                    (.. b.prefix :/tc)
                    :-type
                    :f
                    :-name
                    :*.sh
                    :-exec
                    :chmod
                    :-v
                    :755
                    "{}"
                    "+"]))}
