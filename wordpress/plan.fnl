;; wordpress, ported from its plan.sh.
{:name "wordpress"
 :origin "karate"
 :version "4.7.4"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "installs wordpress"
 :upstream_url "https://wordpress.org/"
 :source {:url "https://wordpress.org/wordpress-4.7.4.tar.gz" :sha256 "c11ce7580f21dfbca70dd6f817d3376385be6d34cf4d86f233eae3acb5fd87fd"}
 :deps ["karate/php" "karate/curl" "karate/wordpress-proxy/4.7.4" "karate/mysql-client"]
 :svc {:user "root" :group "root"}
 :binds {"database" ["port" "username" "password"]}
 :build (fn [b]
          nil)
 :install (fn [b]
          (b:copy (b:join b.src "@{cache}/wordpress") (b:join (.. b.prefix "/public_html/") (: (b:join b.src "@{cache}/wordpress") :match "[^/]+$"))))}
