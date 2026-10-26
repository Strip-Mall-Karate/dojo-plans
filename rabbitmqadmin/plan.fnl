;; rabbitmqadmin, ported from its plan.sh.
{:name "rabbitmqadmin"
 :origin "karate"
 :version "3.7.7"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MPL"]
 :description "Open source multi-protocol messaging broker (Administration CLI)"
 :upstream_url "https://www.rabbitmq.com"
 :source {:url "https://raw.githubusercontent.com/rabbitmq/rabbitmq-management/v3.7.7/bin/rabbitmqadmin" :sha256 "81697d08d1ffb533369ad836af1f643854725c10269e74084ccce5dcdbf87163"}
 :deps ["karate/python2" "karate/coreutils"]
 :bin_dirs ["bin"]
 :unpack (fn [b]
          (b:mkdir (.. b.name "-" b.version))
          (b:move (b:join b.cache "rabbitmqadmin") (b:join (.. b.name "-" b.version "/") (: (b:join b.cache "rabbitmqadmin") :match "[^/]+$"))))
 :build (fn [b]
          (b:fix_interpreter [(b:join b.src "rabbitmqadmin")] "karate/coreutils" "bin/env"))
 :install (fn [b]
          (b:copy (b:join b.src "rabbitmqadmin") (.. b.prefix "/bin/rabbitmqadmin"))
          (b:chmod (.. b.prefix "/bin/rabbitmqadmin") "755")
          (b:chmod (.. b.prefix "/bin/rabbitmqadmin") "+x"))}
