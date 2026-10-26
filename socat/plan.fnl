;; socat, ported from its plan.sh.
{:name "socat"
 :origin "karate"
 :version "1.7.3.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0"]
 :description "Multipurpose relay for bidirectional data transfer between two independent data channels"
 :upstream_url "http://www.dest-unreach.org/socat/"
 :source {:url "http://www.dest-unreach.org/socat/download/socat-1.7.3.2.tar.gz" :sha256 "ce3efc17e3e544876ebce7cd6c85b3c279fda057b2857fcaaf67b9ab8bdaf034"}
 :deps ["karate/glibc" "karate/readline" "karate/openssl"]
 :build_deps ["karate/make" "karate/gcc"]
 :bin_dirs ["bin"]}
