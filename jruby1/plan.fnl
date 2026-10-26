;; jruby1, ported from its plan.sh.
{:name "jruby1"
 :origin "karate"
 :version "1.7.27"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["EPL 1.0" "GPL-2.0" "LGPL-2.1"]
 :description "A high performance, stable, fully threaded Java implementation of the Ruby programming language."
 :upstream_url "https://github.com/jruby/jruby"
 :source {:url "https://github.com/jruby/jruby/archive/1.7.27.tar.gz" :sha256 "25628ef9b5ba3018563ae625c1534de3472b3a95b184aef6d8ef6731378909b7" :dirname "jruby-1.7.27"}
 :deps ["karate/bash" "karate/coreutils" "karate/glibc" "karate/corretto8"]
 :build_deps ["karate/corretto8" "karate/make" "karate/which"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:env "JAVA_HOME" (b:path_for "karate/corretto8"))
          (b:run ["./mvnw"]))
 :install (fn [b]
          (each [_ p (ipairs (b:glob b.src "*"))] (b:copy p (b:join (.. b.prefix "/") (: p :match "[^/]+$"))))
          (b:fix_interpreter (b:glob (.. b.prefix "/bin") "*") "karate/bash" "bash")
          (b:run ["find" (.. b.prefix "/lib/jni/") "-maxdepth" "1" "-mindepth" "1" "-type" "d" "-not" "-name" "x86_64-Linux" "-exec" "rm" "-rf" "{}" ";"]))}
