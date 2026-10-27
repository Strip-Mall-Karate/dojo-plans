;; libzip, ported from its plan.sh.
{:name :libzip
 :origin :karate
 :version :1.5.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:BSD-3-Clause]
 :description "A C library for reading, creating, and modifying zip archives"
 :upstream_url "https://libzip.org/"
 :source {:url "https://libzip.org//download/libzip-1.5.1.tar.gz"
          :sha256 :47eaa45faa448c72bd6906e5a096846c469a185f293cafd8456abb165841b3f2}
 :deps [:karate/bzip2-musl :karate/openssl :karate/zlib]
 :build_deps [:karate/bzip2-musl
              :karate/cmake
              :karate/gcc
              :karate/gcc-libs
              :karate/make
              :karate/openssl
              :karate/zlib]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :prepare (fn [b]
            ;; From do_setup_environment.
            (b:buildtime_env :BUILD_DIR :build)
            (b:mkdir (or (b:getenv :BUILD_DIR) "")))
 :build (fn [b]
          (b:run [:cmake
                  (.. :-DCMAKE_INSTALL_PREFIX= b.prefix)
                  (.. :-DCMAKE_INSTALL_LIBDIR= b.prefix :/lib/)
                  (.. :-DCMAKE_PREFIX_PATH= (b:path_for :zlib))
                  (.. :-DZLIB_INCLUDE_DIR= (b:path_for :zlib) :/include)
                  (.. :-DOPENSSL_INCLUDE_DIR= (b:path_for :openssl) :/include)
                  (.. :-DOPENSSL_ROOT_DIR= (b:path_for :openssl))
                  ".."] {:cwd (or (b:getenv :BUILD_DIR) "")})
          (b:run [:make :-j (tostring b.jobs)]
                 {:cwd (or (b:getenv :BUILD_DIR) "")}))
 :install (fn [b]
            (b:run [:make :install] {:cwd (or (b:getenv :BUILD_DIR) "")}))}
