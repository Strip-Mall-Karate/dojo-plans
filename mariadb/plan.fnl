;; mariadb, ported from its plan.sh.
;; mariadb 13.0.2, the latest release on 2026-10-26: 10.1.24's source no longer downloads.
{:name :mariadb
 :origin :karate
 :version :13.0.2
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-2.0]
 :description "An open source monitoring software for networks and applications"
 :upstream_url "https://mariadb.org/"
 :source {:url "https://archive.mariadb.org/mariadb-13.0.2/source/mariadb-13.0.2.tar.gz"
          :sha256 :8ee8d955530faedcea344535de85495afb5b98128bbf660e56893e93e21ee8f7}
 :deps [:karate/gcc-libs :karate/ncurses :karate/zlib]
 :build_deps [:karate/gcc :karate/make :karate/coreutils :karate/cmake]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :svc {:user :doj}
 :exports {:port :port}
 :exposes [:port]
 :prepare (fn [b]
            (when (b:exists (b:join b.src :CMakeCache.txt))
              (b:remove (b:join b.src :CMakeCache.txt)))
            (let [text (b:read (b:join b.src :CMakeLists.txt))
                  ends (= (text:sub -1) "\n")
                  lines []
                  out []]
              (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")]
                (table.insert lines l))
              (each [_n l (ipairs lines)]
                (var line l)
                (local deleted false)
                (local after [])
                (when (not deleted)
                  (set line
                       (pick-values 1 (string.gsub line :^.*abi_check.*$ "#" 1))))
                (when (not deleted) (table.insert out line))
                (each [_ x (ipairs after)] (table.insert out x)))
              (b:write (b:join b.src :CMakeLists.txt)
                       (.. (table.concat out "\n")
                           (if (and ends (> (length out) 0))
                               "\n"
                               ""))))
            (let [text (b:read (b:join b.src :sql/CMakeLists.txt))
                  ends (= (text:sub -1) "\n")
                  lines []
                  out []]
              (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")]
                (table.insert lines l))
              (each [_n l (ipairs lines)]
                (var line l)
                (local deleted false)
                (local after [])
                (when (not deleted)
                  (set line
                       (pick-values 1
                                    (string.gsub line :data/test
                                                 "${INSTALL_MYSQLTESTDIR}"))))
                (when (not deleted) (table.insert out line))
                (each [_ x (ipairs after)] (table.insert out x)))
              (b:write (b:join b.src :sql/CMakeLists.txt)
                       (.. (table.concat out "\n")
                           (if (and ends (> (length out) 0))
                               "\n"
                               ""))))
            (b:env :CXXFLAGS (or (b:getenv :CFLAGS) "")))
 :build (fn [b]
          (b:run [:cmake
                  "."
                  (.. :-DCMAKE_INSTALL_PREFIX= b.prefix)
                  (.. :-DCMAKE_PREFIX_PATH= (b:path_for :karate/ncurses))
                  :-DCMAKE_BUILD_TYPE=Release
                  :-DWITH_READLINE=OFF])
          (b:run [:make]))
 :install (fn [b]
            (b:run [:make :install])
            (b:remove (.. b.prefix :/mysql-test))
            (b:remove (.. b.prefix :/bin/mysql_client_test))
            (b:remove (.. b.prefix :/bin/mysql_test)))}
