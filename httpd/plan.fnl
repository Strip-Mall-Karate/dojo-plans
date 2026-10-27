;; httpd, ported from its plan.sh.
{:name :httpd
 :origin :karate
 :version :2.4.38
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0]
 :description "The Apache HTTP Server"
 :upstream_url "http://httpd.apache.org/"
 :source {:url "https://archive.apache.org/dist/httpd/httpd-2.4.38.tar.gz"
          :sha256 :38d0b73aa313c28065bf58faf64cec12bf7c7d5196146107df2ad07541aa26a6}
 :deps [:karate/apr
        :karate/apr-util
        :karate/bash
        :karate/expat
        :karate/gcc-libs
        :karate/glibc
        :karate/libiconv
        :karate/openssl
        :karate/pcre
        :karate/perl
        :karate/zlib
        :karate/sed
        :karate/grep]
 :build_deps [:karate/patch :karate/make :karate/gcc]
 :bin_dirs [:bin]
 :include_dirs [:include]
 :svc {:run "httpd -DFOREGROUND -f /doj/svc/httpd/config/httpd.conf"
       :user :root
       :group :root}
 :exports {:port :serverport}
 :exposes [:port]
 :build (fn [b]
          (b:run [:./configure
                  (.. :--prefix= b.prefix)
                  (.. :--with-expat= (b:path_for :karate/expat))
                  (.. :--with-iconv= (b:path_for :karate/libiconv))
                  (.. :--with-pcre= (b:path_for :karate/pcre))
                  (.. :--with-apr= (b:path_for :karate/apr))
                  (.. :--with-apr-util= (b:path_for :karate/apr-util))
                  (.. :--with-z= (b:path_for :karate/zlib))
                  (.. :--with-ssl= (b:path_for :karate/openssl))
                  :--enable-modules=none
                  :--enable-mods-static=none
                  :--enable-mods-shared=reallyall
                  "--enable-mpms-shared=prefork event worker"])
          (b:run [:make]))}
