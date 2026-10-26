;; protobuf, ported from its plan.sh.
{:name "protobuf"
 :origin "karate"
 :version "3.6.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["BSD"]
 :description "Protocol buffers are a language-neutral, platform-neutral extensible mechanism for serializing structured data."
 :upstream_url "https://developers.google.com/protocol-buffers/"
 :source {:url "https://github.com/google/protobuf/releases/download/v3.6.1/protobuf-all-3.6.1.tar.gz" :sha256 "fd65488e618032ac924879a3a94fa68550b3b5bcb445b93b7ddf3c925b1a351f"}
 :deps ["karate/gcc" "karate/zlib"]
 :build_deps ["karate/make"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]}
