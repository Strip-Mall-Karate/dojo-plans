;; msgpack, ported from its plan.sh.
{:name "msgpack"
 :origin "karate"
 :version "2.1.5"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["BSL-1.0"]
 :description "MessagePack implementation for C and C++"
 :upstream_url "https://github.com/msgpack/msgpack-c"
 :source {:url "https://github.com/msgpack/msgpack-c/releases/download/cpp-2.1.5/msgpack-2.1.5.tar.gz" :sha256 "6126375af9b204611b9d9f154929f4f747e4599e6ae8443b337915dcf2899d2b"}
 :deps ["karate/glibc"]
 :build_deps ["karate/cmake" "karate/doxygen" "karate/gcc" "karate/make"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["cmake" "." (.. "-DCMAKE_INSTALL_PREFIX=" b.prefix) (.. "-DDOXYGEN_EXECUTABLE=" (b:path_for "doxygen") "/bin/doxygen") (.. "-DZLIB_INCLUDE_DIR=" (b:path_for "zlib") "/include") (.. "-DZLIB_LIBRARY=" (b:path_for "zlib") "/libz.so")])
          (b:run ["make"]))}
