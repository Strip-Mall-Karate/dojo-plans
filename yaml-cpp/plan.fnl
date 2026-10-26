;; yaml-cpp, ported from its plan.sh.
{:name "yaml-cpp"
 :origin "karate"
 :version "0.6.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "A YAML parser and emitter in C++"
 :upstream_url "https://github.com/jbeder/yaml-cpp"
 :source {:url "https://github.com/jbeder/yaml-cpp/archive/yaml-cpp-0.6.2.tar.gz" :sha256 "e4d8560e163c3d875fd5d9e5542b5fd5bec810febdcba61481fe5fc4e6b1fd05" :dirname "yaml-cpp-yaml-cpp-0.6.2"}
 :deps ["karate/gcc-libs" "karate/glibc"]
 :build_deps ["karate/cmake" "karate/make" "karate/gcc"]
 :lib_dirs ["lib"]
 :include_dirs ["include/yaml-cpp" "include/gtest" "include/gmock"]
 :build (fn [b]
          (b:run ["cmake" (.. "-DCMAKE_INSTALL_PREFIX:PATH=" b.prefix) (.. "-DCMAKE_CXX_FLAGS:STRING=" (or (b:getenv "CXXFLAGS") "") " " (or (b:getenv "CPPFLAGS") "")) (.. "-DCMAKE_C_FLAGS:STRING=" (or (b:getenv "CFLAGS") "") " " (or (b:getenv "CPPFLAGS") "")) "-DCMAKE_BUILD_TYPE=RelWithDebInfo" "."]))
 :install (fn [b]
          (b:run ["make" "install"]))}
