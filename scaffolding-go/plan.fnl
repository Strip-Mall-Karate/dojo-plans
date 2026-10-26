;; scaffolding-go, ported from its plan.sh: its package is lib/scaffolding.fnl.
{:name "scaffolding-go"
 :origin "karate"
 :version "0.1.0"
 :targets ["x86_64-linux" "aarch64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "Scaffolding for Go Applications"
 :upstream_url "https://github.com/Strip-Mall-Karate/dojo-plans"
 :deps ["karate/go" "karate/git" "karate/gcc" "karate/make"]
 :scaffolding "karate/scaffolding-base"}
