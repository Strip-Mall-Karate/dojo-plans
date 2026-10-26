;; postgresql11-client, ported from its plan.sh.
;; Built from the postgresql11 plan, with its own changes.
{:name "postgresql11-client"
 :origin "karate"
 :version "11.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["PostgreSQL"]
 :description "PostgreSQL is a powerful, open source object-relational database system."
 :upstream_url "https://www.postgresql.org/"
 :source {:url "https://ftp.postgresql.org/pub/source/v11.2/postgresql-11.2.tar.bz2" :sha256 "2676b9ce09c21978032070b6794696e0aa5a476e3d21d60afc036dc0a9c09405" :dirname "postgresql-11.2"}
 :deps ["karate/bash" "karate/gawk" "karate/glibc" "karate/grep" "karate/libossp-uuid" "karate/openssl" "karate/perl" "karate/readline" "karate/zlib"]
 :build_deps ["karate/coreutils" "karate/gcc" "karate/make"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["./configure" "--disable-rpath" "--with-openssl" (.. "--prefix=" b.prefix) "--with-uuid=ossp" (.. "--with-includes=" (or (b:getenv "LD_INCLUDE_PATH") "")) (.. "--with-libraries=" (or (b:getenv "LD_LIBRARY_PATH") "")) "--sysconfdir=/doj/svc/postgresql11-client/config" "--localstatedir=/doj/svc/postgresql11-client/var"])
          (b:run ["make" (.. "--jobs=" (tostring b.jobs)) "world"]))
 :install (fn [b]
          (var v-target "")
          (b:run ["make" "-C" "src/bin" "install"])
          (b:run ["make" "-C" "src/include" "install"])
          (b:run ["make" "-C" "src/interfaces" "install"])
          (b:log "Purging unneeded execs")
          (each [_ v-unneeded (ipairs ["ecpg" "initdb" "pg_archivecleanup" "pg_controldata" "pg_resetxlog" "pg_rewind" "pg_test_fsync" "pg_test_timing" "pg_upgrade" "pg_xlogdump"])]
            (set v-target (.. b.prefix "/bin/" v-unneeded)) (b:log (.. "rm -f " v-target)) (b:remove v-target))
          (b:log "Purging unneeded includes")
          (each [_ v-unneeded (ipairs ["postgresql/informix" "postgresql/server"])]
            (set v-target (.. b.prefix "/include/" v-unneeded)) (b:log (.. "rm -rf " v-target)) (b:remove v-target)))}
