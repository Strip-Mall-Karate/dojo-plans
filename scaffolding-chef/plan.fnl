;; scaffolding-chef, ported from its plan.sh.
{:name "scaffolding-chef"
 :origin "karate"
 :version "0.5.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "Scaffolding for Chef Policyfiles"
 :upstream_url "https://www.chef.sh"
 :download (fn [b]
          nil)
 :verify (fn [b]
          nil)
 :unpack (fn [b]
          nil)
 :build (fn [b]
          nil)
 :install (fn [b]
          (b:copy (.. b.plan_dir "/lib/scaffolding.sh") (.. b.prefix "/lib/scaffolding.sh"))
          (b:chmod (.. b.prefix "/lib/scaffolding.sh") "0644"))}
