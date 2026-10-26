;; rlwrap, ported from its plan.sh.
{:name "rlwrap"
 :origin "karate"
 :version "0.43"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0"]
 :description "A readline wrapper"
 :upstream_url "https://github.com/hanslub42/rlwrap"
 :source {:url "https://github.com/hanslub42/rlwrap/releases/download/v0.43/rlwrap-0.43.tar.gz" :sha256 "8e86d0b7882d9b8a73d229897a90edc207b1ae7fa0899dca8ee01c31a93feb2f"}
 :deps ["karate/ncurses" "karate/readline"]
 :build_deps ["karate/gcc" "karate/make"]
 :bin_dirs ["bin"]}
