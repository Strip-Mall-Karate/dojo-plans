;; redis, ported from its plan.sh.
{:name "redis"
 :origin "karate"
 :version "4.0.14"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["BSD-3-Clause"]
 :description "Persistent key-value database, with built-in net interface"
 :upstream_url "http://redis.io/"
 :source {:url "http://download.redis.io/releases/redis-4.0.14.tar.gz" :sha256 "1e1e18420a86cfb285933123b04a82e1ebda20bfb0a289472745a087587e93a7"}
 :deps ["karate/glibc"]
 :build_deps ["karate/make" "karate/gcc"]
 :bin_dirs ["bin"]
 :svc {:run "redis-server /doj/svc/redis/config/redis.config"}
 :exports {"port" "port"}
 :exposes ["port"]
 :build (fn [b]
          (b:run ["make"]))}
