;; postgresql93, ported from its plan.sh.
;; Built from the postgresql plan, with its own changes.
;; The plan's do_clean is not ported: a build empties its source directory before
;; unpacking and starts with no state from an earlier one.
(var v-ext-postgis-cache-path "")
(var v-ext-postgis-dirname "")
{:name "postgresql93"
 :origin "karate"
 :version "9.3.23"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["PostgreSQL"]
 :description "PostgreSQL is a powerful, open source object-relational database system."
 :upstream_url "https://www.postgresql.org/"
 :source {:url "https://ftp.postgresql.org/pub/source/v9.3.23/postgresql-9.3.23.tar.bz2" :sha256 "1d981006dce3851e470b038e88bf496a80813c614c2e89ed7d2c7fb38e66f6cb" :dirname "postgresql-9.3.23"}
 :deps ["karate/bash" "karate/glibc" "karate/openssl" "karate/perl" "karate/readline" "karate/zlib" "karate/libossp-uuid" "karate/libxml2" "karate/geos" "karate/proj" "karate/gdal"]
 :build_deps ["karate/coreutils" "karate/gcc" "karate/make" "karate/perl" "karate/diffutils"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :exports {"port" "port" "superuser_name" "superuser.name" "superuser_password" "superuser.password"}
 :exposes ["port"]
 :download (fn [b]
          ;; From do_before.
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
          (b:run ["./configure" "--disable-rpath" "--with-openssl" (.. "--prefix=" b.prefix) "--with-uuid=ossp" (.. "--with-includes=" (or (b:getenv "LD_INCLUDE_PATH") "")) (.. "--with-libraries=" (or (b:getenv "LD_LIBRARY_PATH") "")) "--sysconfdir=/doj/svc/postgresql93/config" "--localstatedir=/doj/svc/postgresql93/var"])
          (b:run ["make" "world"]))
 :install (fn [b]
          (b:run ["make" "install-world"])
          (var v-doj-library-path (.. (b:path_for "proj") "/lib:" b.prefix "/lib"))
          (b:env "LIBRARY_PATH" (.. (or (b:getenv "LIBRARY_PATH") "") ":" v-doj-library-path))
          (b:log (.. "Added dojo libraries to LIBRARY_PATH: " v-doj-library-path))
          (b:env "PATH" (.. (or (b:getenv "PATH") "") ":" b.prefix "/bin"))
          (b:log (.. "Added postgresql binaries to PATH: " b.prefix "/bin"))
          (b:log (.. "Building " v-ext-postgis-dirname))
          (b:run ["./configure" (.. "--prefix=" b.prefix)] {:cwd v-ext-postgis-cache-path})
          (b:run ["make"] {:cwd v-ext-postgis-cache-path})
          (b:log (.. "Installing " v-ext-postgis-dirname))
          (b:run ["make" "install"] {:cwd v-ext-postgis-cache-path}))}
