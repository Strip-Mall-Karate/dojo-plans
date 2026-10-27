;; mysql-client, ported from its plan.sh.
{:name :mysql-client
 :origin :karate
 :version :5.7.21
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-2.0]
 :description "MySQL Client Tools"
 :upstream_url "https://www.mysql.com/"
 :source {:url "http://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.21.tar.gz"
          :sha256 :fa205079c27a39c24f3485e7498dd0906a6e0b379b4f99ebc0ec38a9ec5b09b7
          :dirname :mysql-5.7.21}
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
 :build_deps [:karate/boost159
              :karate/cmake
              :karate/diffutils
              :karate/gcc
              :karate/make
              :karate/patch]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :build (fn [b]
          (b:run [:cmake
                  "."
                  (.. :-DLOCAL_BOOST_DIR= (b:path_for :karate/boost159))
                  (.. :-DBOOST_INCLUDE_DIR= (b:path_for :karate/boost159)
                      :/include)
                  (.. :-DWITH_BOOST= (b:path_for :karate/boost159))
                  (.. :-DCURSES_LIBRARY= (b:path_for :karate/ncurses)
                      :/lib/libcurses.so)
                  (.. :-DCURSES_INCLUDE_PATH= (b:path_for :karate/ncurses)
                      :/include)
                  :-DWITH_SSL=yes
                  (.. :-DOPENSSL_INCLUDE_DIR= (b:path_for :karate/openssl)
                      :/include)
                  (.. :-DOPENSSL_LIBRARY= (b:path_for :karate/openssl)
                      :/lib/libssl.so)
                  (.. :-DCRYPTO_LIBRARY= (b:path_for :karate/openssl)
                      :/lib/libcrypto.so)
                  "-DWITHOUT_SERVER:BOOL=ON"
                  (.. :-DCMAKE_INSTALL_PREFIX= b.prefix)])
          (b:run [:make (.. :--jobs= (tostring b.jobs))]))
 :check (fn [b]
          (b:run [:ctest]))
 :install (fn [b]
            (b.default.install b)
            (each [_ p (ipairs (b:glob (.. b.prefix :/lib) :*.a))]
              (b:remove p))
            (each [_ p (ipairs (b:glob (.. b.prefix :/bin) :mysqld_*))]
              (b:remove p))
            (b:fix_interpreter [(.. b.prefix :/bin/mysqldumpslow)] :karate/perl
                               :bin/perl))}
