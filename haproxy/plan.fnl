;; haproxy, ported from its plan.sh.
{:name :haproxy
 :origin :karate
 :version :1.9.4
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-2.0 :LGPL-2.1]
 :description "The Reliable, High Performance TCP/HTTP Load Balancer"
 :upstream_url "https://www.haproxy.org/"
 :source {:url "https://www.haproxy.org/download/1.9/src/haproxy-1.9.4.tar.gz"
          :sha256 :8483fe12b30256f83d542b3f699e165d8f71bf2dfac8b16bb53716abce4ba74f}
 :deps [:karate/zlib :karate/pcre :karate/openssl]
 :build_deps [:karate/coreutils
              :karate/gcc
              :karate/pcre
              :karate/make
              :karate/openssl
              :karate/zlib
              :karate/diffutils]
 :bin_dirs [:bin]
 :svc {:run "haproxy -f config/haproxy.conf -db" :user :root :group :root}
 :exports {:port :front-end.port :status-port :status.port}
 :exposes [:port :status-port]
 :binds {:backend [:port]}
 :build (fn [b]
          (b:run [:make
                  :USE_PCRE=1
                  :USE_PCRE_JIT=1
                  :TARGET=linux2628
                  :USE_OPENSSL=1
                  :USE_ZLIB=1
                  :USE_GETADDRINFO=1
                  (.. :ADDINC= (or (b:getenv :CFLAGS) ""))
                  (.. :ADDLIB= (or (b:getenv :LDFLAGS) ""))]))
 :install (fn [b]
            (b:mkdir (.. b.prefix :/bin))
            (if (b:exists (.. b.prefix :/bin))
                (b:copy (b:join b.src :haproxy)
                        (b:join (.. b.prefix :/bin)
                                (: (b:join b.src :haproxy) :match "[^/]+$")))
                (b:copy (b:join b.src :haproxy) (.. b.prefix :/bin))))}
