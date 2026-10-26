;; memcached, ported from its plan.sh.
{:name "memcached"
 :origin "karate"
 :version "1.5.12"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["BSD"]
 :description "Distributed memory object caching system"
 :upstream_url "https://memcached.org/"
 :source {:url "http://www.memcached.org/files/memcached-1.5.12.tar.gz" :sha256 "c02f97d5685617b209fbe25f3464317b234d765b427d254c2413410a5c095b29"}
 :deps ["karate/glibc" "karate/cyrus-sasl" "karate/libevent"]
 :build_deps ["karate/git" "karate/gcc" "karate/make"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :svc {:run "memcached"}
 :exports {"port" "port"}
 :exposes ["port"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--enable-sasl"])
          (b:run ["make"]))}
