;; c-ares, ported from its plan.sh.
{:name :c-ares
 :origin :karate
 :version :1.15.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "A C library for asynchronous DNS requests"
 :upstream_url "https://c-ares.haxx.se/"
 :source {:url "https://github.com/c-ares/c-ares/archive/cares-1_15_0.tar.gz"
          :sha256 :7deb7872cbd876c29036d5f37e30c4cbc3cc068d59d8b749ef85bb0736649f04
          :dirname :c-ares-cares-1_15_0}
 :deps [:karate/glibc :karate/gcc-libs]
 :build_deps [:karate/coreutils
              :karate/busybox-static
              :karate/diffutils
              :karate/file
              :karate/gcc
              :karate/cmake
              :karate/ninja]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]
 :download (fn [b]
             ;; From do_begin.
             (b:env :DOJ_ENV_CMAKE_FIND_ROOT_PATH_SEPARATOR ";")
             (b:env :DOJ_ENV_CMAKE_FIND_ROOT_PATH_TYPE :aggregate)
             (b.default.download b))
 :prepare (fn [b]
            ;; From do_setup_environment.
            (b:buildtime_env :BUILDDIR :build)
            (b:runtime_env_push :CMAKE_FIND_ROOT_PATH
                                (.. b.prefix :/lib/cmake/c-ares))
            (b:mkdir (or (b:getenv :BUILDDIR) "")))
 :build (fn [b]
          (b:run [:cmake
                  (.. :-DCMAKE_INSTALL_PREFIX= (or (b:getenv :PREFIX) ""))
                  :-DCARES_STATIC=ON
                  :-DCARES_INSTALL=ON
                  (.. :-DCARES_BUILD_TESTS= (or (b:getenv :DO_CHECK) ""))
                  :-DCARES_BUILD_TOOLS=ON
                  :-G
                  :Ninja
                  ".."] {:cwd (or (b:getenv :BUILDDIR) "")})
          (b:run [:ninja (.. :-j (b:capture [:nproc :--ignore=1]))]
                 {:cwd (or (b:getenv :BUILDDIR) "")}))
 :check (fn [b]
          (b:run [:ctest :-R :aresfuzz]
                 {:cwd (or (b:getenv :BUILDDIR) "")
                  :env {:CTEST_OUTPUT_ON_FAILURE :1}})
          (b:run [:./bin/arestest
                  :-4
                  "--gtest_filter=-*.Live*:AddressFamilies/MockChannelTest.HostAliasUnreadable*"]
                 {:cwd (or (b:getenv :BUILDDIR) "")})
          (when (string.find (b:capture [:ifconfig]
                                        {:cwd (or (b:getenv :BUILDDIR) "")})
                             :inet6)
            (b:log "HAS IPV6")
            (b:run [:./bin/arestest
                    :-6
                    "--gtest_filter=-*.Live*:AddressFamilies/MockChannelTest.HostAliasUnreadable*"]
                   {:cwd (or (b:getenv :BUILDDIR) "")})))
 :install (fn [b]
            (b:run [:ninja :install] {:cwd (or (b:getenv :BUILDDIR) "")}))}
