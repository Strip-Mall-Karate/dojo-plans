;; ant, ported from its plan.sh.
{:name "ant"
 :origin "karate"
 :version "1.9.7"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :source {:url "https://github.com/apache/ant/archive/rel/1.9.7.tar.gz" :sha256 "53dbfb13e0e9bf1b34bcbfdf807c1b9df1b89362b176e1e58150906f518b2c88"}
 :deps ["karate/coreutils" "karate/jdk8"]
 :build_deps ["karate/jdk8"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:env "JAVA_HOME" (b:path_for "karate/jdk8"))
          (b:run ["sh" "./build.sh" (.. "-Ddist.dir=" b.prefix) "dist"] {:cwd (.. b.cache "/" b.name "-rel-" b.version)}))
 :install (fn [b]
          nil)}
