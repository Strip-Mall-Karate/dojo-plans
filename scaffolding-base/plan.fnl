;; scaffolding-base, ported from its plan.sh: the scaffolding for scaffoldings,
;; packaging itself as it packages them.
{:name :scaffolding-base
 :origin :karate
 :version :0.1.0
 :targets [:x86_64-linux :aarch64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0]
 :description "The scaffolding for scaffoldings: a plan using it packages its lib/scaffolding.fnl."
 :build (fn [_b] nil)
 :install (fn [b]
            (b:copy (b:join b.plan_dir :lib/scaffolding.fnl)
                    (b:join b.prefix :lib/scaffolding.fnl))
            (b:chmod (b:join b.prefix :lib/scaffolding.fnl) :644))}
