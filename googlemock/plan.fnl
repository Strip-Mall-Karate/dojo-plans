;; googlemock, ported from its plan.sh.
{:name :googlemock
 :origin :karate
 :version :1.8.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:bsd-3-clause]
 :description "The Google C++ mocking framework."
 :upstream_url "https://github.com/google/googletest/tree/master/googlemock"
 :source {:url "https://github.com/google/googletest/archive/release-1.8.0.tar.gz"
          :sha256 :58a6f4277ca2bc8565222b3bbd58a177609e9c488e8a72649359ba51450db7d8
          :dirname :googletest-release-1.8.0}
 :deps [:karate/gcc-libs :karate/glibc]
 :build_deps [:karate/cmake :karate/gcc :karate/make]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]
 :prepare (fn [b]
            (b:env :GTEST_TARGET b.name)
            (b:log (.. "Plan Setting GTEST_TARGET="
                       (or (b:getenv :GTEST_TARGET) "")))
            (b:mkdir (b:join b.src :build))
            (b:mkdir (b:join b.src
                             (.. :build/ (or (b:getenv :GTEST_TARGET) "")))))
 :build (fn [b]
          (b:run [:cmake
                  (.. :-Dgtest_build_samples= (or (b:getenv :DO_CHECK) ""))
                  (.. :-Dgmock_build_samples= (or (b:getenv :DO_CHECK) ""))
                  (.. :-Dgtest_build_tests= (or (b:getenv :DO_CHECK) ""))
                  (.. :-Dgmock_build_tests= (or (b:getenv :DO_CHECK) ""))
                  (.. :-DCMAKE_INSTALL_PREFIX= (or (b:getenv :PREFIX) ""))
                  (.. "../../" (or (b:getenv :GTEST_TARGET) ""))]
                 {:cwd (.. :build/ (or (b:getenv :GTEST_TARGET) ""))})
          (b:run [:make] {:cwd (.. :build/ (or (b:getenv :GTEST_TARGET) ""))}))
 :check (fn [b]
          (b:run [:make :test]
                 {:cwd (.. :build/ (or (b:getenv :GTEST_TARGET) ""))
                  :env {:CTEST_OUTPUT_ON_FAILURE :1}}))
 :install (fn [b]
            (b:run [:make :install]
                   {:cwd (.. :build/ (or (b:getenv :GTEST_TARGET) ""))})
            (b:copy (b:join (b:join b.src
                                    (.. (.. :build/
                                            (or (b:getenv :GTEST_TARGET) ""))
                                        "/../.."))
                            :googlemock/LICENSE)
                    (.. b.prefix :/share/licenses/license.txt))
            (b:chmod (.. b.prefix :/share/licenses/license.txt) :644)
            (b:mkdir (.. b.prefix :/lib/pkgconfig))
            (b:write (.. b.prefix :/lib/pkgconfig/libgmock.pc) (.. "Name: libgmock
Description: The Google C++ mocking framework.
Version: "
                                                                   b.version
                                                                   "\nCflags: -I"
                                                                   b.prefix
                                                                   "/include/gmock
Libs: -L"
                                                                   b.prefix "/lib -lgmock -lgmock_main
")))}
