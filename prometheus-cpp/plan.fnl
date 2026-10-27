;; prometheus-cpp, ported from its plan.sh.
;; The source project's plan cloned the v0.6.0 tag and its submodules with git,
;; unverified. These are the tag's archive and each submodule at the commit the
;; tag records, pinned.
{:name :prometheus-cpp
 :origin :karate
 :version :0.6.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "Prometheus Client Library for Modern C++"
 :upstream_url "https://github.com/jupp0r/prometheus-cpp"
 :build_deps [:karate/glibc
              :karate/benchmark
              :karate/cacerts
              :karate/openssl
              :karate/curl
              :karate/cmake
              :karate/ninja
              :karate/gcc
              :karate/git
              :karate/pkg-config]
 :lib_dirs [:lib64]
 :include_dirs [:include]
 :source {:url "https://github.com/jupp0r/prometheus-cpp/archive/v0.6.0.tar.gz"
          :sha256 :2486b4e2daf36d6c9da5f683938757d0774ca8c3fef587d20e7ffdd14d36f276
          :filename :prometheus-cpp-0.6.0.tar.gz
          :dirname :prometheus-cpp-0.6.0}
 :download (fn [b]
             ;; From do_begin.
             (b:env :DOJ_ENV_CMAKE_FIND_ROOT_PATH_SEPARATOR ";")
             (b:env :DOJ_ENV_CMAKE_FIND_ROOT_PATH_TYPE :aggregate)
             (b.default.download b)
             ;; The submodules at the commits v0.6.0 records.
             (b:download "https://github.com/civetweb/civetweb/archive/fbdee7440be24f904208c15a1fc9e2582b866049.tar.gz"
                         :8bf320432b7840245c9caf717a6027b30eaf52948e05e694c5149e9dd066f603
                         :civetweb-fbdee7440be2.tar.gz)
             (b:download "https://github.com/google/googletest/archive/2fe3bd994b3189899d93f1d5a881e725e046fdc2.tar.gz"
                         :d0d447b4feeedca837a0d46a289d4223089b32ac2f84545fa4982755cc8919be
                         :googletest-2fe3bd994b31.tar.gz))
 :unpack (fn [b]
           (b.default.unpack b)
           (each [_ [dir archive] (ipairs [[:civetweb
                                            :civetweb-fbdee7440be2.tar.gz]
                                           [:googletest
                                            :googletest-2fe3bd994b31.tar.gz]])]
             (b:mkdir (b:join b.src (.. :3rdparty/ dir)))
             (b:run [:tar :xf (b:join b.cache archive) :--strip-components=1]
                    {:cwd (b:join b.src (.. :3rdparty/ dir))})))
 :prepare (fn [b]
            ;; From do_setup_environment.
            (b:buildtime_env :BUILDDIR :_build)
            (b:runtime_env_push :CMAKE_FIND_ROOT_PATH
                                (.. b.prefix :/lib64/cmake/prometheus-cpp))
            (b:mkdir (or (b:getenv :BUILDDIR) "")))
 :build (fn [b]
          (var v--benchmark-path "")
          (var v--curl-path "")
          (set v--benchmark-path (b:path_for :karate/benchmark))
          (set v--curl-path (b:path_for :karate/curl))
          (b:run [:cmake
                  (.. :-DCMAKE_INSTALL_PREFIX= b.prefix)
                  (.. :-DCMAKE_FIND_ROOT_PATH=
                      (or (b:getenv :CMAKE_FIND_ROOT_PATH) ""))
                  :-DENABLE_COMPRESSION=OFF
                  (.. :-DENABLE_TESTING= (or (b:getenv :DO_CHECK) ""))
                  (.. :-DGoogleBenchmark_LIBRARY= v--benchmark-path
                      :/lib/libbenchmark.a)
                  (.. :-DGoogleBenchmark_INCLUDE_DIR= v--benchmark-path
                      :/include)
                  (.. :-DCURL_LIBRARY= v--curl-path :/lib/libcurl.so)
                  (.. :-DCURL_INCLUDE_DIR= v--curl-path :/include)
                  :-G
                  :Ninja
                  ".."] {:cwd (or (b:getenv :BUILDDIR) "")})
          (b:run [:ninja] {:cwd (or (b:getenv :BUILDDIR) "")}))
 :check (fn [b]
          (b:run [:ctest :-V]
                 {:cwd (or (b:getenv :BUILDDIR) "")
                  :env {:LD_LIBRARY_PATH (.. (b:path_for :karate/glibc) "/lib:"
                                             (b:path_for :karate/gcc) :/lib)}}))
 :install (fn [b]
            (b:run [:ninja :install] {:cwd (or (b:getenv :BUILDDIR) "")}))}
