;; php, ported from its plan.sh.
;; php 8.5.12, the latest release on 2026-10-26: 7.3.3's source no longer downloads.
{:name :php
 :origin :karate
 :version :8.5.12
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:PHP-3.01]
 :description "PHP is a popular general-purpose scripting language that is especially suited to web development."
 :upstream_url "http://php.net/"
 :source {:url "https://www.php.net/distributions/php-8.5.12.tar.xz"
          :sha256 :08bc2eba2a588654ade1357174aa646b761556c862dda0678345ee29ed481209}
 :deps [:karate/bzip2
        :karate/coreutils
        :karate/curl
        :karate/glibc
        :karate/icu
        :karate/libjpeg-turbo
        :karate/libpng
        :karate/libxml2
        :karate/libzip
        :karate/openssl
        :karate/readline
        :karate/zip
        :karate/zlib
        :karate/gcc-libs]
 :build_deps [:karate/autoconf
              :karate/bison2
              :karate/gcc
              :karate/libgd
              :karate/make
              :karate/re2c]
 :bin_dirs [:bin :sbin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :interpreters [:bin/php]
 :build (fn [b]
          (b:run [:./configure
                  (.. :--prefix= b.prefix)
                  :--enable-exif
                  :--enable-fpm
                  :--with-fpm-user=doj
                  :--with-fpm-group=doj
                  :--enable-mbstring
                  :--enable-opcache
                  :--with-mysqli=mysqlnd
                  :--with-pdo-mysql=mysqlnd
                  (.. :--with-readline= (b:path_for :readline))
                  (.. :--with-curl= (b:path_for :curl))
                  :--with-gd
                  (.. :--with-jpeg-dir= (b:path_for :libjpeg-turbo))
                  (.. :--with-libxml-dir= (b:path_for :libxml2))
                  (.. :--with-openssl= (b:path_for :openssl))
                  (.. :--with-png-dir= (b:path_for :libpng))
                  :--with-xmlrpc
                  (.. :--with-zlib= (b:path_for :zlib))
                  :--enable-zip
                  (.. :--with-libzip= (b:path_for :libzip))
                  (.. :--with-bz2= (b:path_for :bzip2))
                  :--enable-intl])
          (b:run [:make :-j (tostring b.jobs)]))
 :check (fn [b]
          (b:run [:make :test]))
 :install (fn [b]
            (b.default.install b)
            (if (b:exists (.. b.prefix :/etc/php-fpm.conf))
                (b:move (.. b.prefix :/etc/php-fpm.conf.default)
                        (b:join (.. b.prefix :/etc/php-fpm.conf)
                                (: (.. b.prefix :/etc/php-fpm.conf.default)
                                   :match "[^/]+$")))
                (b:move (.. b.prefix :/etc/php-fpm.conf.default)
                        (.. b.prefix :/etc/php-fpm.conf))))}
