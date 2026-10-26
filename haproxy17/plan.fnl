;; haproxy17, ported from its plan.sh.
;; Built from the haproxy plan, with its own changes.
{:name "haproxy17"
 :origin "karate"
 :version "1.7.11"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0" "LGPL-2.1"]
 :description "The Reliable, High Performance TCP/HTTP Load Balancer"
 :upstream_url "https://www.haproxy.org/"
 :source {:url "https://www.haproxy.org/download/1.7/src/haproxy-1.7.11.tar.gz" :sha256 "d564b8e9429d1e8e13cb648bf4694926b472e36da1079df946bb732927b232ea" :dirname "haproxy-1.7.11"}
 :deps ["karate/zlib" "karate/pcre" "karate/openssl"]
 :build_deps ["karate/coreutils" "karate/gcc" "karate/pcre" "karate/make" "karate/openssl" "karate/zlib"]
 :bin_dirs ["bin"]
 :svc {:run "haproxy -f config/haproxy.conf -db" :user "root" :group "root"}
 :exports {"port" "front-end.port" "status-port" "status.port"}
 :exposes ["port" "status-port"]
 :binds {"backend" ["port"]}
 :build (fn [b]
          (b:run ["make" "USE_PCRE=1" "USE_PCRE_JIT=1" "TARGET=linux2628" "USE_OPENSSL=1" "USE_ZLIB=1" "USE_GETADDRINFO=1" (.. "ADDINC=" (or (b:getenv "CFLAGS") "")) (.. "ADDLIB=" (or (b:getenv "LDFLAGS") ""))]))
 :install (fn [b]
          (b:mkdir (.. b.prefix "/bin"))
          (if (b:exists (.. b.prefix "/bin"))
            (b:copy (b:join b.src "haproxy") (b:join (.. b.prefix "/bin") (: (b:join b.src "haproxy") :match "[^/]+$")))
            (b:copy (b:join b.src "haproxy") (.. b.prefix "/bin"))))}
