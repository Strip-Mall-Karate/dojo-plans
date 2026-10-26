;; valgrind, ported from its plan.sh.
{:name "valgrind"
 :origin "karate"
 :version "3.12.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0"]
 :description "An instrumentation framework for building dynamic analysis tools"
 :upstream_url "http://www.valgrind.org/"
 :source {:url "http://www.valgrind.org/downloads/valgrind-3.12.0.tar.bz2" :sha256 "67ca4395b2527247780f36148b084f5743a68ab0c850cb43e4a5b4b012cf76a1"}
 :deps ["karate/glibc"]
 :build_deps ["karate/gcc" "karate/make" "karate/which" "karate/diffutils" "karate/perl"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :check (fn [b]
          (b:run ["make" "check"]))
 :strip (fn [b]
          (b:log "Skipping symbol stripping"))}
