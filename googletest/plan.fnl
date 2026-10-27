;; googletest, ported from its plan.sh.
{:name :googletest
 :origin :karate
 :version :1.8.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:bsd-3-clause]
 :description "Google C++ Testing Framework helps you write better C++ tests."
 :upstream_url "https://github.com/google/googletest"
 :source {:url "https://github.com/google/googletest/archive/release-1.8.1.tar.gz"
          :sha256 :9bf1fe5182a604b4135edc1a425ae356c9ad15e9b23f9f12a02e80184c3a249c
          :dirname :googletest-release-1.8.1}
 :deps [:karate/gcc-libs :karate/glibc]
 :build_deps [:karate/cmake :karate/gcc :karate/make :karate/python2]
 :lib_dirs [:lib64]
 :include_dirs [:include]
 :pconfig_dirs [:lib64/pkgconfig]
 :download (fn [b]
             ;; From do_begin.
             (b:env :DOJ_ENV_CMAKE_FIND_ROOT_PATH_SEPARATOR ";")
             (b:env :DOJ_ENV_CMAKE_FIND_ROOT_PATH_TYPE :aggregate)
             (b.default.download b))
 :prepare (fn [b]
            ;; From do_setup_environment.
            (b:buildtime_env :BUILD_DIR :build)
            (b:runtime_env_push :CMAKE_FIND_ROOT_PATH
                                (.. b.prefix :/lib64/cmake/GTest))
            (b:mkdir (or (b:getenv :BUILD_DIR) ""))
            (let [text (b:read (b:join b.src :CMakeLists.txt))
                  ends (= (text:sub -1) "\n")
                  lines []
                  out []]
              (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")]
                (table.insert lines l))
              (each [n l (ipairs lines)]
                (var line l)
                (var deleted false)
                (local after [])
                (when (not deleted)
                  (set line
                       (pick-values 1
                                    (string.gsub line
                                                 "GOOGLETEST_VERSION 1.9.0"
                                                 (.. "GOOGLETEST_VERSION "
                                                     (pick-values 1
                                                                  (: b.version
                                                                     :gsub "%%"
                                                                     "%%%%")))
                                                 1))))
                (when (not deleted) (table.insert out line))
                (each [_ x (ipairs after)] (table.insert out x)))
              (b:write (b:join b.src :CMakeLists.txt)
                       (.. (table.concat out "\n")
                           (if (and ends (> (length out) 0))
                               "\n"
                               "")))))
 :build (fn [b]
          (b:run [:cmake
                  (.. :-Dgtest_build_samples= (or (b:getenv :DO_CHECK) ""))
                  (.. :-Dgtest_build_tests= (or (b:getenv :DO_CHECK) ""))
                  (.. :-Dgmock_build_tests= (or (b:getenv :DO_CHECK) ""))
                  (.. :-DCMAKE_INSTALL_PREFIX= (or (b:getenv :PREFIX) ""))
                  ".."] {:cwd (or (b:getenv :BUILD_DIR) "")})
          (b:run [:make (.. :-j (b:capture [:nproc :--ignore=1]))]
                 {:cwd (or (b:getenv :BUILD_DIR) "")}))
 :check (fn [b]
          (b:run [:make :test (.. :-j (b:capture [:nproc :--ignore=1]))]
                 {:cwd (or (b:getenv :BUILD_DIR) "")
                  :env {:CTEST_OUTPUT_ON_FAILURE :1}}))
 :install (fn [b]
            (b:run [:make :install] {:cwd (or (b:getenv :BUILD_DIR) "")})
            (b:copy (b:join b.src :LICENSE)
                    (.. b.prefix :/share/licenses/license.txt))
            (b:chmod (.. b.prefix :/share/licenses/license.txt) :644))}
