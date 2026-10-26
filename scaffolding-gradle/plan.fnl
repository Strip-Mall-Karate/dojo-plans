;; scaffolding-gradle, ported from its plan.sh.
{:name "scaffolding-gradle"
 :origin "karate"
 :version "0.6.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "Dojo Plan Scaffolding for Node.js Applications"
 :upstream_url "https://github.com/Strip-Mall-Karate/dojo-plans/tree/master/scaffolding-node"
 :deps ["karate/tar" "karate/rq"]
 :build_deps ["karate/coreutils"]
 :build (fn [b]
          nil)
 :install (fn [b]
          (each [v-f (: (b:capture ["find" "lib" "-type" "f"]) :gmatch "[^
          ]+")]
            (b:copy (if (= (: v-f :sub 1 1) "/") v-f (b:join b.src v-f)) (.. b.prefix "/" v-f)) (b:chmod (.. b.prefix "/" v-f) "0644")))}
