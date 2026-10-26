;; The scaffolding for scaffoldings. A plan using it is a scaffolding: it has
;; no source and nothing to build, and its package is its plan's
;; lib/scaffolding.fnl, the module Dojo loads for the plans that use it.
{:build (fn [b] nil)
 :install (fn [b]
            (b:copy (b:join b.plan_dir "lib/scaffolding.fnl") (b:join b.prefix "lib/scaffolding.fnl"))
            (b:chmod (b:join b.prefix "lib/scaffolding.fnl") "644"))}
