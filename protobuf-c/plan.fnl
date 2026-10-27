;; protobuf-c, ported from its plan.sh.
{:name :protobuf-c
 :origin :karate
 :version :1.3.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:BSD-2-Clause]
 :description "Protocol Buffers implementation in C"
 :upstream_url "https://github.com/protobuf-c/protobuf-c"
 :source {:url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.3.1/protobuf-c-1.3.1.tar.gz"
          :sha256 :51472d3a191d6d7b425e32b612e477c06f73fe23e07f6a6a839b11808e9d2267}
 :deps [:karate/gcc-libs :karate/protobuf-cpp :karate/zlib]
 :build_deps [:karate/gcc :karate/make :karate/pkg-config]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :build (fn [b]
          (b:run [:./configure (.. :--prefix= b.prefix)])
          (b:run [:make]))
 :check (fn [b]
          (b:run [:make :check]))}
