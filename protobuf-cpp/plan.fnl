;; protobuf-cpp, ported from its plan.sh.
{:name :protobuf-cpp
 :origin :karate
 :version :3.6.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:BSD]
 :description "Google's language-neutral, platform-neutral, extensible mechanism for serializing structured data."
 :upstream_url "https://github.com/google/protobuf"
 :source {:url "https://github.com/google/protobuf/releases/download/v3.6.1/protobuf-cpp-3.6.1.tar.gz"
          :sha256 :b3732e471a9bb7950f090fd0457ebd2536a9ba0891b7f3785919c654fe2a2529
          :dirname :protobuf-3.6.1}
 :deps [:karate/gcc :karate/zlib]
 :build_deps [:karate/make]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]}
