;; curl-static-musl, ported from its plan.sh.
;; Built from the curl plan, with its own changes.
{:name :curl-static-musl
 :origin :karate
 :version :7.63.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:curl]
 :description "curl is an open source command line tool and library for
transferring data with URL syntax."
 :upstream_url "https://curl.haxx.se/"
 :source {:url "https://curl.haxx.se/download/curl-7.63.0.tar.gz"
          :sha256 :d483b89062832e211c887d7cf1b65c902d591b48c11fe7d174af781681580b41
          :dirname :curl-7.63.0}
 :deps [:karate/cacerts]
 :build_deps [:karate/coreutils
              :karate/gcc
              :karate/make
              :karate/musl
              :karate/openssl-musl
              :karate/zlib-musl]
 :bin_dirs [:bin]
 :prepare (fn [b]
            (b:env :CC :musl-gcc)
            (b:log (.. "Setting CC=" (or (b:getenv :CC) ""))))
 :build (fn [b]
          (b:run [:./configure
                  (.. :--prefix= b.prefix)
                  (.. :--with-ca-bundle= (b:path_for :cacerts)
                      :/ssl/certs/cacert.pem)
                  (.. :--with-ssl= (b:path_for :openssl-musl))
                  (.. :--with-zlib= (b:path_for :zlib-musl))
                  :--disable-manual
                  :--disable-ldap
                  :--disable-ldaps
                  :--disable-rtsp
                  :--enable-proxy
                  :--enable-optimize
                  :--disable-dependency-tracking
                  :--enable-ipv6
                  :--without-libidn
                  :--without-gnutls
                  :--without-librtmp
                  :--enable-static
                  :--disable-shared]
                 {:env {:LDFLAGS :-static :PKG_CONFIG "pkg-config --static"}})
          (b:run [:make :curl_LDFLAGS=-all-static]))
 :install (fn [b]
            (b:run [:make :install])
            (b:remove (.. b.prefix :/bin/curl-config))
            (b:remove (.. b.prefix :/include))
            (b:remove (.. b.prefix :/lib))
            (b:remove (.. b.prefix :/share)))}
