;; nginx, ported from its plan.sh.
{:name :nginx
 :origin :karate
 :version :1.15.9
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:BSD-2-Clause]
 :description "NGINX web server."
 :upstream_url "https://nginx.org/"
 :source {:url "https://nginx.org/download/nginx-1.15.9.tar.gz"
          :sha256 :e4cfba989bba614cd53f3f406ac6da9f05977d6b1296e5d20a299f10c2d7ae43}
 :deps [:karate/glibc
        :karate/libedit
        :karate/ncurses
        :karate/zlib
        :karate/bzip2
        :karate/openssl
        :karate/pcre]
 :build_deps [:karate/gcc :karate/make :karate/coreutils]
 :bin_dirs [:sbin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :svc {:run :nginx :user :root}
 :exports {:port :http.listen.port}
 :exposes [:port]
 :build (fn [b]
          (b:run [:./configure
                  (.. :--prefix= b.prefix)
                  :--conf-path=/doj/svc/nginx/config/nginx.conf
                  (.. :--sbin-path= b.prefix :/bin/nginx)
                  :--pid-path=/doj/svc/nginx/var/nginx.pid
                  :--lock-path=/doj/svc/nginx/var/nginx.lock
                  :--user=doj
                  :--group=doj
                  :--http-log-path=/dev/stdout
                  :--error-log-path=stderr
                  :--http-client-body-temp-path=/doj/svc/nginx/var/client-body
                  :--http-proxy-temp-path=/doj/svc/nginx/var/proxy
                  :--http-fastcgi-temp-path=/doj/svc/nginx/var/fastcgi
                  :--http-scgi-temp-path=/doj/svc/nginx/var/scgi
                  :--http-uwsgi-temp-path=/doj/svc/nginx/var/uwsgi
                  :--with-ipv6
                  :--with-pcre
                  :--with-pcre-jit
                  :--with-file-aio
                  :--with-stream=dynamic
                  :--with-stream_ssl_module
                  :--with-mail=dynamic
                  :--with-http_gunzip_module
                  :--with-http_gzip_static_module
                  :--with-http_realip_module
                  :--with-http_v2_module
                  :--with-http_ssl_module
                  :--with-http_stub_status_module
                  :--with-http_addition_module
                  :--with-http_degradation_module
                  :--with-http_flv_module
                  :--with-http_mp4_module
                  :--with-http_secure_link_module
                  :--with-http_sub_module
                  :--with-http_slice_module
                  (.. :--with-cc-opt= (or (b:getenv :CFLAGS) ""))
                  (.. :--with-ld-opt= (or (b:getenv :LDFLAGS) ""))])
          (b:run [:make]))
 :install (fn [b]
            (b:run [:make :install])
            (b:mkdir (.. b.prefix :/sbin))
            (if (b:exists (.. b.prefix :/sbin))
                (b:copy (.. b.cache "/" b.name "-" b.version :/objs/nginx)
                        (b:join (.. b.prefix :/sbin)
                                (: (.. b.cache "/" b.name "-" b.version
                                       :/objs/nginx)
                                   :match "[^/]+$")))
                (b:copy (.. b.cache "/" b.name "-" b.version :/objs/nginx)
                        (.. b.prefix :/sbin))))}
