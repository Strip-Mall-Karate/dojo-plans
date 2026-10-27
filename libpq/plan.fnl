;; libpq, ported from its plan.sh.
{:name :libpq
 :origin :karate
 :version :9.6.8
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:PostgreSQL]
 :description "LibPQ is the client side library for PostgreSQL, a powerful, open source object-relational database system."
 :upstream_url "https://www.postgresql.org/"
 :source {:url "https://ftp.postgresql.org/pub/source/v9.6.8/postgresql-9.6.8.tar.bz2"
          :sha256 :eafdb3b912e9ec34bdd28b651d00226a6253ba65036cb9a41cad2d9e82e3eb70
          :dirname :postgresql-9.6.8}
 :deps [:karate/glibc
        :karate/openssl
        :karate/readline
        :karate/zlib
        :karate/libossp-uuid]
 :build_deps [:karate/coreutils :karate/gcc :karate/make]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :build (fn [b]
          (b:run [:./configure
                  :--disable-rpath
                  :--with-openssl
                  (.. :--prefix= b.prefix)
                  :--with-uuid=ossp
                  (.. :--with-includes= (or (b:getenv :LD_INCLUDE_PATH) ""))
                  (.. :--with-libraries= (or (b:getenv :LD_LIBRARY_PATH) ""))
                  :--sysconfdir=/doj/svc/libpq/config
                  :--localstatedir=/doj/svc/libpq/var
                  :--without-tcl
                  :--without-perl
                  :--without-python])
          (b:run [:make]))
 :install (fn [b]
            (var v-target "")
            (b:run [:make :-C :src/bin :install])
            (b:run [:make :-C :src/include :install])
            (b:run [:make :-C :src/interfaces :install])
            (b:log "Purging unneeded execs")
            (each [_ v-unneeded (ipairs [:ecpg
                                         :initdb
                                         :pg_archivecleanup
                                         :pg_config
                                         :pg_controldata
                                         :pg_resetxlog
                                         :pg_rewind
                                         :pg_test_fsync
                                         :pg_test_timing
                                         :pg_upgrade
                                         :pg_xlogdump])]
              (set v-target (.. b.prefix :/bin/ v-unneeded))
              (b:log (.. "rm -f " v-target))
              (b:remove v-target))
            (b:log "Purging unneeded includes")
            (each [_ v-unneeded (ipairs [:postgresql/informix
                                         :postgresql/server])]
              (set v-target (.. b.prefix :/include/ v-unneeded))
              (b:log (.. "rm -rf " v-target))
              (b:remove v-target)))}
