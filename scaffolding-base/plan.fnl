;; scaffolding-base, ported from its plan.sh.
{:name "scaffolding-base"
 :origin "karate"
 :version "0.1.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
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
