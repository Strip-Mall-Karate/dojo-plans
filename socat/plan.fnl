;; socat, ported from its plan.sh.
;; socat 1.8.1.3, the latest release on 2026-10-26: 1.7.3.2's source no longer downloads.
{:name "socat"
 :origin "karate"
 :version "1.8.1.3"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0"]
 :description "Multipurpose relay for bidirectional data transfer between two independent data channels"
 :upstream_url "http://www.dest-unreach.org/socat/"
 :source {:url "http://www.dest-unreach.org/socat/download/socat-1.8.1.3.tar.gz" :sha256 "06602ffd591e98c75b3dc1d66f0f19136cc666b0b2d95caad987d6ab2cb28097"}
 :deps ["karate/glibc" "karate/readline" "karate/openssl"]
 :build_deps ["karate/make" "karate/gcc"]
 :bin_dirs ["bin"]}
