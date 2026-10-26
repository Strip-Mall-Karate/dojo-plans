;; benchmark, ported from its plan.sh.
{:name "benchmark"
 :origin "karate"
 :version "1.4.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "Google's microbenchmark support library"
 :upstream_url "https://github.com/google/benchmark"
 :source {:url "https://github.com/google/benchmark/archive/v1.4.1.tar.gz" :sha256 "f8e525db3c42efc9c7f3bc5176a8fa893a9a9920bbd08cef30fb56a51854d60d" :filename "v1.4.1.tar.gz"}
 :deps ["karate/gcc-libs" "karate/glibc"]
 :build_deps ["karate/binutils" "karate/cmake" "karate/make" "karate/gcc" "karate/git" "karate/googletest"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :download (fn [b]
          ;; From do_begin.
          (b:env "DOJ_ENV_CMAKE_FIND_ROOT_PATH_SEPARATOR" ";")
          (b:env "DOJ_ENV_CMAKE_FIND_ROOT_PATH_TYPE" "aggregate")
          (b.default.download b))
 :prepare (fn [b]
          ;; From do_setup_environment.
          (b:run ["set_buildtime_env" "BUILD_DIR" "_build"])
          (b:run ["push_runtime_env" "CMAKE_FIND_ROOT_PATH" (.. b.prefix "/lib/cmake/benchmark")])
          (b:mkdir (or (b:getenv "BUILD_DIR") "")))
 :build (fn [b]
          (var v-gtest-dir (b:path_for "karate/googletest"))
          (b:run ["cmake" (.. "-DCMAKE_INSTALL_PREFIX=" (or (b:getenv "PREFIX") "")) (.. "-DBENCHMARK_ENABLE_TESTING=" (or (b:getenv "DO_CHECK") "")) (.. "-DBENCHMARK_ENABLE_GTEST_TESTS=" (or (b:getenv "DO_CHECK") "")) (.. "-DGTEST_LIBRARY=" v-gtest-dir "/lib64/libgtest.a") (.. "-DGTEST_MAIN_LIBRARY=" v-gtest-dir "/lib64/libgtest_main.a") (.. "-DGTEST_INCLUDE_DIR=" v-gtest-dir "/include") "-DCMAKE_BUILD_TYPE=RELEASE" ".."] {:cwd (or (b:getenv "BUILD_DIR") "")})
          (b:run ["make" (.. "-j" (b:capture ["nproc" "--ignore=1"]))] {:cwd (or (b:getenv "BUILD_DIR") "")}))
 :check (fn [b]
          (b:run ["make" "test" (.. "-j" (b:capture ["nproc" "--ignore=1"]))] {:cwd (or (b:getenv "BUILD_DIR") "")}))
 :install (fn [b]
          (b:run ["make" "install"] {:cwd (or (b:getenv "BUILD_DIR") "")}))}
