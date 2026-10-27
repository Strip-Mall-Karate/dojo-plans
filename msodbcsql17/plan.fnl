;; msodbcsql17, ported from its plan.sh.
{:name :msodbcsql17
 :origin :karate
 :version :17.2.0.1-1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license ["Microsoft Software License"]
 :description "ODBC driver for SQL server"
 :upstream_url "https://docs.microsoft.com/en-us/sql/connect/odbc/download-odbc-driver-for-sql-server?view=sql-server-2017"
 :source {:url "https://packages.microsoft.com/ubuntu/18.04/prod/pool/main/m/msodbcsql17/msodbcsql17_17.2.0.1-1_amd64.deb"
          :sha256 :dea625abe078bee2431bc3438e8cfb93fb224176a332308eb974855ae716eb9e}
 :deps [:karate/gcc-libs
        :karate/glibc
        :karate/libtool
        :karate/krb5
        :karate/openssl
        :karate/unixodbc
        :karate/util-linux
        :karate/zlib]
 :build_deps [:karate/binutils :karate/dpkg :karate/patchelf]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :unpack (fn [b]
           (b:run [:dpkg
                   :-x
                   (.. b.cache :/msodbcsql17_17.2.0.1-1_amd64.deb)
                   (.. b.cache "/" (.. b.name "-" b.version))]))
 :build (fn [b]
          (b:log "Fixing rpath for lib:")
          (b:run [:find
                  "."
                  :-type
                  :f
                  :-executable
                  :-exec
                  :sh
                  :-c
                  "file -i \"$1\" | grep -q \"x-pie-executable; charset=binary\""
                  "_"
                  "{}"
                  ";"
                  :-print
                  :-exec
                  :patchelf
                  :--set-rpath
                  (or (b:getenv :LD_RUN_PATH) "")
                  "{}"
                  ";"]))
 :install (fn [b]
            (if (b:exists b.prefix)
                (b:copy (b:join (b:join b.src (.. :opt/microsoft/ b.name))
                                :include)
                        (b:join b.prefix
                                (: (b:join (b:join b.src
                                                   (.. :opt/microsoft/ b.name))
                                           :include)
                                   :match "[^/]+$")))
                (b:copy (b:join (b:join b.src (.. :opt/microsoft/ b.name))
                                :include) b.prefix))
            (each [_ p (ipairs (b:glob (b:join (b:join b.src
                                                       (.. :opt/microsoft/
                                                           b.name))
                                               :lib64)
                                       "*"))]
              (b:copy p (b:join (.. b.prefix :/lib/) (: p :match "[^/]+$"))))
            (if (b:exists b.prefix)
                (b:copy (b:join (b:join b.src (.. :opt/microsoft/ b.name))
                                :share)
                        (b:join b.prefix
                                (: (b:join (b:join b.src
                                                   (.. :opt/microsoft/ b.name))
                                           :share)
                                   :match "[^/]+$")))
                (b:copy (b:join (b:join b.src (.. :opt/microsoft/ b.name))
                                :share) b.prefix))
            (b:mkdir (.. b.prefix :/doc))
            (each [_ p (ipairs (b:glob (b:join b.src
                                               (.. :usr/share/doc/ b.name))
                                       "*"))]
              (b:copy p (b:join (.. b.prefix :/doc/) (: p :match "[^/]+$")))))
 :strip (fn [b]
          nil)}
