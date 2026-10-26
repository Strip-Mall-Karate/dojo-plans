;; protobuf2, ported from its plan.sh.
{:name "protobuf2"
 :origin "karate"
 :version "2.6.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["BSD"]
 :description "Protocol buffers are a language-neutral, platform-neutral extensible mechanism for serializing structured data."
 :upstream_url "https://developers.google.com/protocol-buffers/"
 :source {:url "https://github.com/google/protobuf/releases/download/v2.6.1/protobuf-2.6.1.tar.bz2" :sha256 "ee445612d544d885ae240ffbcbf9267faa9f593b7b101f21d58beceb92661910" :dirname "protobuf-2.6.1"}
 :deps ["karate/gcc" "karate/zlib"]
 :build_deps ["karate/make"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]}
