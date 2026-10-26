;; cmake, ported from its plan.sh.
{:name "cmake"
 :origin "karate"
 :version "3.13.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["BSD-3-Clause"]
 :description "CMake is an open-source, cross-platform family of tools designed to build, test and package software"
 :upstream_url "https://cmake.org/"
 :source {:url "https://cmake.org/files/v3.13/cmake-3.13.2.tar.gz" :sha256 "c925e7d2c5ba511a69f43543ed7b4182a7d446c274c7480d0e42cd933076ae25"}
 :deps ["karate/glibc" "karate/gcc-libs" "karate/curl" "karate/zlib"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/make" "karate/gcc"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (var v-zlib (b:path_for "karate/zlib"))
          (var v-zlib-lib (.. v-zlib "/lib"))
          (var v-zlib-include (.. v-zlib "/include"))
          (var v-curl (b:path_for "karate/curl"))
          (var v-curl-lib (.. v-curl "/lib"))
          (var v-curl-include (.. v-curl "/include"))
          (b:run ["./bootstrap" (.. "--parallel=" (tostring b.jobs)) "--system-curl" "--" (.. "-DZLIB_LIBRARY:FILEPATH=" v-zlib-lib "/libz.so") (.. "-DZLIB_INCLUDE_DIR:PATH=" v-zlib-include) (.. "-DCURL_LIBRARY:FILEPATH=" v-curl-lib "/libcurl.so") (.. "-DCURL_INCLUDE_DIR:PATH=" v-curl-include)])
          (b:run ["./configure" (.. "--prefix=" b.prefix)])
          (b:run ["make" "-j" (tostring b.jobs)]))
 :check (fn [b]
          (b:run ["make" "test"]))}
