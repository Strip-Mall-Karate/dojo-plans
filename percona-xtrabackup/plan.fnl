;; percona-xtrabackup, ported from its plan.sh.
{:name "percona-xtrabackup"
 :origin "karate"
 :version "2.4.9"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0"]
 :description "Percona xtrabackup utilities"
 :upstream_url "https://www.percona.com/software/mysql-database/percona-xtrabackup"
 :source {:url "http://github.com/percona/percona-xtrabackup/archive/percona-xtrabackup-2.4.9.tar.gz" :sha256 "53e613e12dbd93277fb3004b66d8d2c12476e4febca2bcd2d0f2115dc18cb265" :dirname "percona-xtrabackup-percona-xtrabackup-2.4.9"}
 :deps ["karate/curl" "karate/gcc-libs" "karate/glibc" "karate/libaio" "karate/libev" "karate/libgcrypt" "karate/libgpg-error" "karate/nghttp2" "karate/openssl" "karate/zlib"]
 :build_deps ["karate/m4" "karate/bison" "karate/boost159" "karate/cmake" "karate/gcc" "karate/make" "karate/ncurses" "karate/vim"]
 :bin_dirs ["bin"]
 :prepare (fn [b]
          (when (b:exists (b:join b.src "CMakeCache.txt"))
            (b:remove (b:join b.src "CMakeCache.txt")))
          (let [text (b:read (b:join b.src "CMakeLists.txt")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line "^.*abi_check.*$" "#" 1))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join b.src "CMakeLists.txt") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" ""))))
          (b:env "CXXFLAGS" (.. (or (b:getenv "CFLAGS") "") " -Wno-error=implicit-fallthrough -fpermissive"))
          (b:env "CPPFLAGS" (.. (or (b:getenv "CPPFLAGS") "") " -Wno-error=implicit-fallthrough")))
 :build (fn [b]
          (b:env "LD_LIBRARY_PATH" (.. (b:path_for "karate/libgcrypt") "/lib"))
          (var v-gcrypt-include-dir (.. (b:path_for "karate/libgcrypt") "/lib"))
          (var v-gcrypt-lib (b:path_for "karate/libgcrypt"))
          (b:run ["cmake" "." (.. "-DCMAKE_PREFIX_PATH=" (b:path_for "karate/ncurses")) (.. "-DCMAKE_INSTALL_PREFIX=" b.prefix) "-DBUILD_CONFIG=xtrabackup_release" "-DWITH_MAN_PAGES=OFF" (.. "-DWITH_BOOST=" (b:path_for "karate/boost159") "/include") (.. "-DCURL_LIBRARY=" (b:path_for "karate/curl") "/lib/libcurl.so") (.. "-DCURL_INCLUDE_DIR=" (b:path_for "karate/curl") "/include") (.. "-DLIBEV_INCLUDE_DIRS=" (b:path_for "karate/libev") "/include") (.. "-DGCRYPT_LIB=" (b:path_for "karate/libgcrypt") "/lib/libgcrypt.so") (.. "-DGCRYPT_INCLUDE_DIR=" (b:path_for "karate/libgcrypt") "/include") (.. "-DGPG_ERROR_LIB=" (b:path_for "karate/libgpg-error") "/lib/libgpg-error.so") (.. "-DLIBEV_LIB=" (b:path_for "karate/libev") "/lib/libev.so") (.. "-DZLIB_LIBRARY=" (b:path_for "karate/zlib") "/lib/libz.so")])
          (b:run ["make"]))
 :install (fn [b]
          (b:run ["make" "install"])
          (b:remove (.. b.prefix "/xtrabackup-test")))}
