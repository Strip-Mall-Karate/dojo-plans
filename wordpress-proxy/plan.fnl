;; wordpress-proxy, ported from its plan.sh.
{:name :wordpress-proxy
 :origin :karate
 :version :4.7.4
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0]
 :description "nginx wordpress proxy"
 :upstream_url "https://nginx.org/"
 :deps [:karate/nginx]
 :svc {:user :root :group :root}
 :download (fn [_b]
             nil)
 :build (fn [_b]
          nil)
 :install (fn [_b]
            nil)}
