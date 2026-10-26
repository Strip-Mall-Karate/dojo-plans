;; scaffolding-node, ported from its plan.sh.
{:name "scaffolding-node"
 :origin "karate"
 :version "0.6.14"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "Dojo Plan Scaffolding for Node.js Applications"
 :upstream_url "https://github.com/Strip-Mall-Karate/dojo-plans/tree/master/scaffolding-node"
 :deps ["karate/tar" "karate/rq" "karate/jq-static" "karate/gawk" "karate/curl" "karate/bc" "karate/coreutils"]
 :build_deps ["karate/node" "karate/coreutils" "karate/yarn"]
 :build (fn [b]
          nil)
 :install (fn [b]
          (each [v-f (: (b:capture ["find" "lib" "-type" "f"]) :gmatch "[^
          ]+")]
            (b:copy (if (= (: v-f :sub 1 1) "/") v-f (b:join b.src v-f)) (.. b.prefix "/" v-f)) (b:chmod (.. b.prefix "/" v-f) "0644")))}
