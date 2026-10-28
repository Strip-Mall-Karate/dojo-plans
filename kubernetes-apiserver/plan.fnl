;; kubernetes-apiserver, ported from its plan.sh.
{:name :kubernetes-apiserver
 :origin :karate
 :version :1.11.2
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0]
 :description "Production-Grade Container Scheduling and Management"
 :upstream_url "https://github.com/kubernetes/kubernetes"
 :deps [:karate/kubernetes/1.11.2]
 :build (fn [_b]
          nil)
 :install (fn [_b]
            nil)}
