;; nghttp2, ported from its plan.sh.
{:name "nghttp2"
 :origin "karate"
 :version "1.34.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "nghttp2 is an open source HTTP/2 C Library."
 :upstream_url "https://nghttp2.org/"
 :source {:url "https://github.com/nghttp2/nghttp2/releases/download/v1.34.0/nghttp2-1.34.0.tar.gz" :sha256 "8889399ddd38aa0405f6e84f1c050a292286089441686b8a9c5e937de4f5b61d"}
 :build_deps ["karate/make" "karate/gcc"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]}
