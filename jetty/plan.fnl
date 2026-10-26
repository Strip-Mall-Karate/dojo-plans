;; jetty, ported from its plan.sh.
{:name "jetty"
 :origin "karate"
 :version "9.1.5"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "Jetty webserver and Java container"
 :upstream_url "https://eclipse.org/jetty"
 :source {:url "http://repo1.maven.org/maven2/org/eclipse/jetty/jetty-distribution/9.1.5.v20140505/jetty-distribution-9.1.5.v20140505.tar.gz" :sha256 "3fbce5530d8d9a66f43034782b0f249df3d98e3e97ef849e7f740eab612b963f"}
 :deps ["karate/which" "karate/coreutils" "karate/bash" "karate/jdk7"]
 :unpack (fn [b]
          (var v-source-dir "")
          (var v-unpack-file "")
          (set v-source-dir (.. b.cache "/" b.name "-" b.version))
          (set v-unpack-file (.. b.cache "/jetty-distribution-9.1.5.v20140505.tar.gz"))
          (b:mkdir v-source-dir)
          (b:run ["tar" "xz" "--strip-components=1" "-f" v-unpack-file] {:cwd v-source-dir}))
 :build (fn [b]
          nil)
 :install (fn [b]
          (b:mkdir (.. b.prefix "/jetty"))
          (each [_ p (ipairs (b:glob b.src "*"))] (b:copy p (b:join (.. b.prefix "/jetty") (: p :match "[^/]+$"))))
          (b:run ["find" (.. b.prefix "/jetty") "-type" "d" "-exec" "chmod" "-v" "755" "{}" "+"])
          (b:run ["find" (.. b.prefix "/jetty") "-type" "f" "-exec" "chmod" "-v" "644" "{}" "+"])
          (b:run ["find" (.. b.prefix "/jetty") "-type" "f" "-name" "*.sh" "-exec" "chmod" "-v" "755" "{}" "+"])
          (b:fix_interpreter [(.. b.prefix "/jetty/bin/jetty.sh")] "karate/coreutils" "bin/env"))}
