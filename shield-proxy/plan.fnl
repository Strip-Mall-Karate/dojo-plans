;; shield-proxy, ported from its plan.sh.
{:name :shield-proxy
 :origin :karate
 :version :0.10.8
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0]
 :description "Proxy package for the Shield backup and restore tool"
 :deps [:karate/nginx :karate/openssl :karate/bash]
 :svc {:user :root :group :root}
 :download (fn [_b]
             nil)
 :build (fn [_b]
          nil)
 :install (fn [_b]
            nil)}
