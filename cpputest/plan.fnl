;; cpputest, ported from its plan.sh.
{:name :cpputest
 :origin :karate
 :version :3.8
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:bsd-3-clause]
 :description "CppUTest is a C/C++ based unit xUnit test framework for unit testing and for test-driving your
code. It is written in C++ but is used in C and C++ projects and frequently used in embedded
systems but it works for any C/C++ project."
 :upstream_url "http://cpputest.github.io"
 :source {:url "https://github.com/cpputest/cpputest/archive/v3.8.tar.gz"
          :sha256 :2b95bb4a568f680cdcca678345a2c41c028275471c2ed7bf0b6f6f1f689c3b76}
 :deps [:karate/gcc-libs :karate/glibc :karate/libtool]
 :build_deps [:karate/cmake
              :karate/gcc
              :karate/m4
              :karate/make
              :karate/pkg-config
              :karate/valgrind]
 :bin_dirs [:sbin]
 :build (fn [b]
          (b:run [:cmake (.. :-DCMAKE_INSTALL_PREFIX= b.prefix) ".."]
                 {:cwd :cpputest_build})
          (b:run [:make] {:cwd :cpputest_build}))
 :check (fn [b]
          (b:run [:make :test] {:cwd :cpputest_build}))
 :install (fn [b]
            (b:run [:make :install] {:cwd :cpputest_build})
            (b:copy (b:join (b:join b.src :cpputest_build) :../COPYING)
                    (.. b.prefix :/share/licenses/license.txt))
            (b:chmod (.. b.prefix :/share/licenses/license.txt) :644))}
