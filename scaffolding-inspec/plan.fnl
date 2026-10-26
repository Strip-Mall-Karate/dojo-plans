;; scaffolding-inspec, ported from its plan.sh.
{:name "scaffolding-inspec"
 :origin "karate"
 :version "0.1.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "Scaffolding for InSpec"
 :upstream_url "https://www.inspec.io"
 :deps ["chef/inspec" "karate/cacerts"]
 :svc {:user "root"}
 :download (fn [b]
          nil)
 :build (fn [b]
          nil)
 :install (fn [b]
          nil)}
