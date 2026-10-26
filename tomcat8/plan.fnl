;; tomcat8, ported from its plan.sh.
{:name "tomcat8"
 :origin "karate"
 :version "8.5.9"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "The Apache Tomcat software is an open source implementation of the Java Servlet, JavaServer Pages, Java Expression Language and Java WebSocket technologies."
 :upstream_url "http://tomcat.apache.org/"
 :source {:url "http://archive.apache.org/dist/tomcat/tomcat-8/v8.5.9/bin/apache-tomcat-8.5.9.tar.gz" :sha256 "d72234baa373234aa9ed78e8331ac1ce47d2e07a262dafce35d17389825bc8b7"}
 :deps ["karate/coreutils"]
 :exports {"port" "server.port"}
 :exposes ["port"]
 :unpack (fn [b]
          (var v-source-dir "")
          (var v-unpack-file "")
          (set v-source-dir (.. b.cache "/" b.name "-" b.version))
          (set v-unpack-file (.. b.cache "/apache-tomcat-8.5.9.tar.gz"))
          (b:mkdir v-source-dir)
          (b:run ["tar" "xz" "--strip-components=1" "-f" v-unpack-file] {:cwd v-source-dir}))
 :build (fn [b]
          nil)
 :install (fn [b]
          (b:log "Performing install")
          (b:mkdir (.. b.prefix "/tc"))
          (each [_ p (ipairs (b:glob b.src "*"))] (b:copy p (b:join (.. b.prefix "/tc") (: p :match "[^/]+$"))))
          (b:run ["find" (.. b.prefix "/tc") "-type" "d" "-exec" "chmod" "-v" "755" "{}" "+"])
          (b:run ["find" (.. b.prefix "/tc") "-type" "f" "-exec" "chmod" "-v" "644" "{}" "+"])
          (b:run ["find" (.. b.prefix "/tc") "-type" "f" "-name" "*.sh" "-exec" "chmod" "-v" "755" "{}" "+"]))}
