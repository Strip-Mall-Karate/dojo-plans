;; mssql, ported from its plan.sh.
{:name "mssql"
 :origin "karate"
 :version "14.0.3025.34-3"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MICROSOFT PRE-RELEASE SOFTWARE LICENSE"]
 :description "Microsoft SQL Server for Linux"
 :upstream_url "https://www.microsoft.com/en-us/sql-server/sql-server-vnext-including-Linux"
 :source {:url "https://packages.microsoft.com/ubuntu/16.04/mssql-server-2017/pool/main/m/mssql-server/mssql-server_14.0.3025.34-3_amd64.deb" :sha256 "359d436c4a40112ab1ce2e2f1e3ef1d4136fa9ffe26eeb7ac18e49d5be6eaee3" :filename "mssql-server_14.0.3025.34-3_amd64.deb"}
 :deps ["karate/libcxx" "karate/libcxxabi" "karate/gcc-libs" "karate/glibc" "karate/jemalloc" "karate/krb5" "karate/numactl" "karate/openssl" "karate/python2" "karate/util-linux"]
 :build_deps ["karate/dpkg" "karate/patchelf"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :svc {:user "root" :group "root"}
 :exports {"port" "port"}
 :exposes ["port"]
 :unpack (fn [b]
          (b:run ["dpkg" "-x" (.. b.cache "/mssql-server_14.0.3025.34-3_amd64.deb") (.. b.cache "/" (.. b.name "-" b.version))]))
 :build (fn [b]
          nil)
 :install (fn [b]
          (var v-elfs-to-patch "")
          (if (b:exists b.prefix)
            (b:copy (b:join b.src "opt/mssql/bin") (b:join b.prefix (: (b:join b.src "opt/mssql/bin") :match "[^/]+$")))
            (b:copy (b:join b.src "opt/mssql/bin") b.prefix))
          (if (b:exists b.prefix)
            (b:copy (b:join b.src "opt/mssql/lib") (b:join b.prefix (: (b:join b.src "opt/mssql/lib") :match "[^/]+$")))
            (b:copy (b:join b.src "opt/mssql/lib") b.prefix))
          (var v-pythonpath (b:path_for "karate/python2"))
          (let [text (b:read (.. b.prefix "/lib/mssql-conf/mssql-conf.py"))] (b:write (.. b.prefix "/lib/mssql-conf/mssql-conf.py") (pick-values 1 (string.gsub text "[^\n]+" (fn [l] (var line l) (set line (pick-values 1 (string.gsub line "/usr/bin/python" (.. (pick-values 1 (: v-pythonpath :gsub "%%" "%%%%")) "/bin/python") 1))) line)))))
          (b:run [(.. b.prefix "/bin/paldumper") (.. b.prefix "/bin/sqlservr") ")"] {:env {"elfs_to_patch" "("}})
          (each [_ v-elf (ipairs v-elfs-to-patch)]
            (b:run ["patchelf" "--interpreter" (.. (b:path_for "glibc") "/lib/ld-linux-x86-64.so.2") "--set-rpath" (or (b:getenv "LD_RUN_PATH") "") v-elf]))
          (b:run ["find" (.. b.prefix "/lib") "-type" "f" "-name" "*.so*" "-exec" "patchelf" "--set-rpath" (or (b:getenv "LD_RUN_PATH") "") "{}" ";"]))
 :strip (fn [b]
          nil)}
