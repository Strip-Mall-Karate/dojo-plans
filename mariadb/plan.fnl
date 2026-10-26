;; mariadb, ported from its plan.sh.
{:name "mariadb"
 :origin "karate"
 :version "10.1.24"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0"]
 :description "An open source monitoring software for networks and applications"
 :upstream_url "https://mariadb.org/"
 :source {:url "http://ftp.hosteurope.de/mirror/archive.mariadb.org//mariadb-10.1.24/source/mariadb-10.1.24.tar.gz" :sha256 "b3df99ae5b1ec8cf6cede4cbc4ae3f54ce66464549cba6d56d9ff4d24e4d551e"}
 :deps ["karate/gcc-libs" "karate/ncurses" "karate/zlib"]
 :build_deps ["karate/gcc" "karate/make" "karate/coreutils" "karate/cmake"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :svc {:user "doj"}
 :exports {"port" "port"}
 :exposes ["port"]
 :prepare (fn [b]
          (when (b:exists (b:join b.src "CMakeCache.txt"))
            (b:remove (b:join b.src "CMakeCache.txt")))
          (let [text (b:read (b:join b.src "CMakeLists.txt"))] (b:write (b:join b.src "CMakeLists.txt") (pick-values 1 (string.gsub text "[^\n]+" (fn [l] (var line l) (set line (pick-values 1 (string.gsub line "^.*abi_check.*$" "#" 1))) line)))))
          (let [text (b:read (b:join b.src "sql/CMakeLists.txt"))] (b:write (b:join b.src "sql/CMakeLists.txt") (pick-values 1 (string.gsub text "[^\n]+" (fn [l] (var line l) (set line (pick-values 1 (string.gsub line "data/test" "${INSTALL_MYSQLTESTDIR}"))) line)))))
          (b:env "CXXFLAGS" (or (b:getenv "CFLAGS") "")))
 :build (fn [b]
          (b:run ["cmake" "." (.. "-DCMAKE_INSTALL_PREFIX=" b.prefix) (.. "-DCMAKE_PREFIX_PATH=" (b:path_for "karate/ncurses")) "-DCMAKE_BUILD_TYPE=Release" "-DWITH_READLINE=OFF"])
          (b:run ["make"]))
 :install (fn [b]
          (b:run ["make" "install"])
          (b:remove (.. b.prefix "/mysql-test"))
          (b:remove (.. b.prefix "/bin/mysql_client_test"))
          (b:remove (.. b.prefix "/bin/mysql_test")))}
