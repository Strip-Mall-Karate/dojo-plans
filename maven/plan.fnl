;; maven, ported from its plan.sh.
{:name :maven
 :origin :karate
 :version :3.3.9
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0]
 :description "A software project management and comprehension tool"
 :upstream_url "https://maven.apache.org/"
 :source {:url "http://apache.cs.utah.edu/maven/maven-3/3.3.9/source/apache-maven-3.3.9-src.tar.gz"
          :sha256 :9150475f509b23518e67a220a9d3a821648ab27550f4ece4d07b92b1fc5611bc
          :dirname :apache-maven-3.3.9}
 :deps [:karate/coreutils :karate/corretto8 :karate/which]
 :build_deps [:karate/ant]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :prepare (fn [b]
            (b:env :JAVA_HOME (b:path_for :corretto8))
            (b:log (.. "Setting JAVA_HOME=" (or (b:getenv :JAVA_HOME) ""))))
 :build (fn [b]
          (b:run [:ant (.. :-Dmaven.home= b.prefix)]))
 :install (fn [_b]
            nil)}
