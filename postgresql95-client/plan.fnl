;; postgresql95-client, ported from its plan.sh.
;; Built from the postgresql95, postgresql plan, with its own changes.
;; The plan's do_clean is not ported: a build empties its source directory before
;; unpacking and starts with no state from an earlier one.
(var v-ext-postgis-cache-path "")
(fn v--copy-service-files [b]
  (b:log "Copying hooks")
  (b:copy (.. b.plan_dir "/../postgresql/hooks") (b:join (.. b.plan_dir "/") (: (.. b.plan_dir "/../postgresql/hooks") :match "[^/]+$")))
  (b:log "Copying config")
  (b:copy (.. b.plan_dir "/../postgresql/config") (b:join (.. b.plan_dir "/") (: (.. b.plan_dir "/../postgresql/config") :match "[^/]+$")))
  (b:log "Copying default.toml")
  (b:copy (.. b.plan_dir "/../postgresql/default.toml") (b:join (.. b.plan_dir "/") (: (.. b.plan_dir "/../postgresql/default.toml") :match "[^/]+$"))))
(fn v--cleanup-copied-service-files [b]
  (b:log "Removing copied files")
  (b:remove (.. b.plan_dir "/config"))
  (b:remove (.. b.plan_dir "/hooks"))
  (b:remove (.. b.plan_dir "/default.toml")))
{:name "postgresql95-client"
 :origin "karate"
 :version "9.5.13"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["PostgreSQL"]
 :description "PostgreSQL is a powerful, open source object-relational database system."
 :upstream_url "https://www.postgresql.org/"
 :source {:url "https://ftp.postgresql.org/pub/source/v9.5.13/postgresql-9.5.13.tar.bz2" :sha256 "5408b86a0b56fd0140c6a0016bf9179bc7817fa03d5571cca346c9ab122ea5ee" :dirname "postgresql-9.5.13"}
 :deps ["karate/bash" "karate/glibc" "karate/openssl" "karate/perl" "karate/readline" "karate/zlib" "karate/libossp-uuid" "karate/libxml2" "karate/geos" "karate/proj" "karate/gdal"]
 :build_deps ["karate/coreutils" "karate/gcc" "karate/make" "karate/perl" "karate/diffutils"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :download (fn [b]
          ;; From do_begin.
          ;; From do_before.
          (var v-ext-postgis-dirname "")
          (set v-ext-postgis-dirname "postgis-2.4.2")
          (set v-ext-postgis-cache-path (.. b.cache "/" v-ext-postgis-dirname))
          (b.default.download b)
          (b:download "http://download.osgeo.org/postgis/source/postgis-2.4.2.tar.gz" "23625bc99ed440d53a20225721095a3f5c653b62421c4d597c8038f0d7a321d9" "postgis-2.4.2.tar.gz"))
 :verify (fn [b]
          (b.default.verify b))
 :unpack (fn [b]
          (b.default.unpack b)
          (b:run ["tar" "xf" (b:join b.cache "postgis-2.4.2.tar.gz")] {:cwd b.cache}))
 :build (fn [b]
          (b:run ["./configure" "--disable-rpath" "--with-openssl" (.. "--prefix=" b.prefix) "--with-uuid=ossp" (.. "--with-includes=" (or (b:getenv "LD_INCLUDE_PATH") "")) (.. "--with-libraries=" (or (b:getenv "LD_LIBRARY_PATH") "")) "--sysconfdir=/doj/svc/postgresql95-client/config" "--localstatedir=/doj/svc/postgresql95-client/var"])
          (b:run ["make" "world"]))
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
            (set v-target (.. b.prefix "/include/" v-unneeded)) (b:log (.. "rm -rf " v-target)) (b:remove v-target)))
 :strip (fn [b]
          (b.default.strip b)
          ;; From do_end.
          )}
