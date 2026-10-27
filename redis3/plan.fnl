;; redis3, ported from its plan.sh.
;; Built from the redis plan, with its own changes.
{:name :redis3
 :origin :karate
 :version :3.2.13
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:BSD-3-Clause]
 :description "Persistent key-value database, with built-in net interface"
 :upstream_url "http://redis.io"
 :source {:url "http://download.redis.io/releases/redis-3.2.13.tar.gz"
          :sha256 :862979c9853fdb1d275d9eb9077f34621596fec1843e3e7f2e2f09ce09a387ba
          :dirname :redis-3.2.13}
 :deps [:karate/glibc]
 :build_deps [:karate/make :karate/gcc]
 :bin_dirs [:bin]
 :svc {:run "redis-server /doj/svc/redis3/config/redis.config"}
 :exports {:port :port}
 :exposes [:port]
 :build (fn [b]
          (b:run [:make]))}
