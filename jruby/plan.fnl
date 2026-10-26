;; jruby, ported from its plan.sh.
{:name "jruby"
 :origin "karate"
 :version "9.2.4.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["EPL 1.0, GPL 2 and LGPL 2.1"]
 :description "A high performance, stable, fully threaded Java implementation of the Ruby programming language."
 :upstream_url "https://github.com/jruby/jruby"
 :source {:url "https://github.com/jruby/jruby/archive/9.2.4.0.tar.gz" :sha256 "9b926cbca56faa9d724753c044c89d86bb48c0b5c26c5bf39120e89dc2fb0c69"}
 :deps ["karate/glibc" "karate/corretto8" "karate/bash" "karate/coreutils"]
 :build_deps ["karate/which" "karate/make" "karate/corretto8"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:env "JAVA_HOME" (b:path_for "karate/corretto8"))
          (b:run ["./mvnw"]))
 :install (fn [b]
          (each [_ p (ipairs (b:glob b.src "*"))] (b:copy p (b:join (.. b.prefix "/") (: p :match "[^/]+$"))))
          (each [_ v-binstub (ipairs (b:glob (.. b.prefix "/bin") "*"))]
            (when (b:exists v-binstub)
            (let [text (b:read v-binstub) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line "/usr/bin/env bash" (.. (pick-values 1 (: (b:path_for "bash") :gsub "%%" "%%%%")) "/bin/bash") 1))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write v-binstub (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" ""))))) (when (b:exists v-binstub)
            (let [text (b:read v-binstub) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line "/usr/bin/env jruby" (.. (pick-values 1 (: b.prefix :gsub "%%" "%%%%")) "/bin/jruby") 1))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write v-binstub (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" ""))))))
          (b:run ["find" (.. b.prefix "/lib/jni/") "-maxdepth" "1" "-mindepth" "1" "-type" "d" "-not" "-name" "x86_64-Linux" "-exec" "rm" "-rf" "{}" ";"]))}
