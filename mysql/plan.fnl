;; mysql, ported from its plan.sh.
{:name :mysql
 :origin :karate
 :version :5.7.21
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-2.0]
 :description "Starts MySQL with a basic configuration. Configurable at run time:

* root_password: the password for the mysql root user, empty by default
* app_username: the username for an application that will connect to the database server, false by default
* app_password: the password for the app user
* bind: the bind address to listen for connections, default 127.0.0.1

Set the app_username and app_password at runtime to have that user created, it will not be otherwise."
 :upstream_url "https://www.mysql.com/"
 :source {:url "http://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.21.tar.gz"
          :sha256 :fa205079c27a39c24f3485e7498dd0906a6e0b379b4f99ebc0ec38a9ec5b09b7}
 :deps [:karate/coreutils
        :karate/gawk
        :karate/gcc-libs
        :karate/glibc
        :karate/grep
        :karate/inetutils
        :karate/ncurses
        :karate/openssl
        :karate/pcre
        :karate/perl
        :karate/procps-ng
        :karate/sed]
 :build_deps [:karate/bison
              :karate/boost159
              :karate/cmake
              :karate/diffutils
              :karate/gcc
              :karate/make
              :karate/patch]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :svc {:user :doj}
 :exports {:port :port
           :password :app_password
           :username :app_username
           :server_id :server_id}
 :build (fn [b]
          (b:run [:cmake
                  "."
                  (.. :-DLOCAL_BOOST_DIR= (b:path_for :karate/boost159))
                  (.. :-DBOOST_INCLUDE_DIR= (b:path_for :karate/boost159)
                      :/include)
                  (.. :-DWITH_BOOST= (b:path_for :karate/boost159))
                  (.. :-DCURSES_INCLUDE_PATH= (b:path_for :karate/ncurses)
                      :/include)
                  (.. :-DCURSES_LIBRARY= (b:path_for :karate/ncurses)
                      :/lib/libcurses.so)
                  :-DWITH_SSL=yes
                  (.. :-DOPENSSL_INCLUDE_DIR= (b:path_for :karate/openssl)
                      :/include)
                  (.. :-DOPENSSL_LIBRARY= (b:path_for :karate/openssl)
                      :/lib/libssl.so)
                  (.. :-DCRYPTO_LIBRARY= (b:path_for :karate/openssl)
                      :/lib/libcrypto.so)
                  (.. :-DCMAKE_INSTALL_PREFIX= b.prefix)
                  :-DWITH_EMBEDDED_SERVER=no
                  :-DWITH_EMBEDDED_SHARED_LIBRARY=no])
          (b:run [:make (.. :--jobs= (tostring b.jobs))]))
 :check (fn [b]
          (b:run [:ctest]))
 :install (fn [b]
            (b.default.install b)
            (b:remove (.. b.prefix :/docs))
            (b:remove (.. b.prefix :/man))
            (b:remove (.. b.prefix :/mysql-test))
            (each [_ p (ipairs (b:glob (.. b.prefix :/lib) :*.a))]
              (b:remove p))
            (b:fix_interpreter [(.. b.prefix :/bin/mysqld_multi)] :karate/perl
                               :bin/perl)
            (b:fix_interpreter [(.. b.prefix :/bin/mysqldumpslow)] :karate/perl
                               :bin/perl))}
