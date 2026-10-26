;; scaffolding-ruby, ported from its plan.sh: its package is
;; lib/scaffolding.fnl and the support programs in libexec. The bash
;; scaffolding read Gemfile.lock with its own Ruby program (bin/gemfile-parser)
;; and default.toml with rq; the Fennel module reads them itself.
{:name "scaffolding-ruby"
 :origin "karate"
 :version "0.8.10"
 :targets ["x86_64-linux" "aarch64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "Dojo Plan Scaffolding for Ruby Applications"
 :upstream_url "https://github.com/Strip-Mall-Karate/dojo-plans/tree/main/scaffolding-ruby"
 :deps ["karate/bundler" "karate/ruby" "karate/tar" "karate/busybox-static" "karate/gcc" "karate/make" "karate/pkg-config"]
 :build (fn [b] nil)
 :install (fn [b]
            (b:copy (b:join b.plan_dir "lib/scaffolding.fnl") (b:join b.prefix "lib/scaffolding.fnl"))
            (b:chmod (b:join b.prefix "lib/scaffolding.fnl") "644")
            (each [_ f (ipairs (b:glob (b:join b.plan_dir "libexec") "*"))]
              (b:copy f (b:join b.prefix "libexec" (f:match "[^/]+$")))
              (b:chmod (b:join b.prefix "libexec" (f:match "[^/]+$")) "755")))}
