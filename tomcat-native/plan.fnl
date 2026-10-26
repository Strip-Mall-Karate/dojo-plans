;; tomcat-native, ported from its plan.sh.
{:name "tomcat-native"
 :origin "karate"
 :version "1.2.8"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache 2.0"]
 :description "The Apache Tomcat Native Library is an optional component for use with Apache Tomcat that allows Tomcat to use certain native resources for performance, compatibility, etc."
 :upstream_url "http://tomcat.apache.org/native-doc/"
 :source {:url "http://archive.apache.org/dist/tomcat/tomcat-connectors/native/1.2.8/source/tomcat-native-1.2.8-src.tar.gz" :sha256 "408ece0b027c8967b3aa85533c5fca642827e235b1857d28df918a4eab861d30"}
 :deps ["karate/apr"]
 :build_deps ["karate/gcc" "karate/make" "karate/openssl" "karate/jdk8"]
 :lib_dirs ["lib"]
 :build (fn [b]
          (b:run ["./configure" (.. "--with-apr=" (b:path_for "karate/apr")) (.. "--with-java-home=" (b:path_for "karate/jdk8")) (.. "--with-ssl=" (b:path_for "karate/openssl")) (.. "--prefix=" b.prefix)] {:cwd (.. b.cache "/" b.name "-" b.version "-src/native")})
          (b:run ["make"] {:cwd (.. b.cache "/" b.name "-" b.version "-src/native")}))
 :install (fn [b]
          (b:run ["make" "install"] {:cwd (.. b.cache "/" b.name "-" b.version "-src/native")}))}
