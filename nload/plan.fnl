;; nload, ported from its plan.sh.
{:name "nload"
 :origin "karate"
 :version "0.7.4"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0-or-later"]
 :description "Real time network traffic monitor for the text console"
 :upstream_url "https://github.com/rolandriegel/nload"
 :source {:url "https://github.com/rolandriegel/nload/archive/v0.7.4.tar.gz" :sha256 "a73b3a75356776860fc4c40daebce04c5022f73d39704a12fb0aeb88a751216a"}
 :deps ["karate/glibc" "karate/gcc-libs" "karate/ncurses"]
 :build_deps ["karate/make" "karate/gcc" "karate/automake" "karate/autoconf"]
 :bin_dirs ["bin"]
 :prepare (fn [b]
          (b:run ["./run_autotools"]))}
