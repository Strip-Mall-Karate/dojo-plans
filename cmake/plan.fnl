;; cmake, ported from its plan.sh.
;; cmake 4.4.4, the latest release on 2026-10-27: 3.13.2 does not build with gcc 16.
{:name "cmake"
 :origin "karate"
 :version "4.4.4"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["BSD-3-Clause"]
 :description "CMake is an open-source, cross-platform family of tools designed to build, test and package software"
 :upstream_url "https://cmake.org/"
 :source {:url "https://cmake.org/files/v4.4/cmake-4.4.4.tar.gz" :sha256 "bd24c30d80a7744ae84b845ff080cc8453b06c622ef01066564108e9cefc44cf"}
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
          (b:run ["./bootstrap" (.. "--prefix=" b.prefix) (.. "--parallel=" (tostring b.jobs)) "--system-curl" "--" "-DHAVE_EFTYPE:INTERNAL=0" (.. "-DZLIB_LIBRARY:FILEPATH=" v-zlib-lib "/libz.so") (.. "-DZLIB_INCLUDE_DIR:PATH=" v-zlib-include) (.. "-DCURL_LIBRARY:FILEPATH=" v-curl-lib "/libcurl.so") (.. "-DCURL_INCLUDE_DIR:PATH=" v-curl-include)])
          (b:run ["make" "-j" (tostring b.jobs)]))
 :check (fn [b]
          (b:run ["make" "test"]))}
