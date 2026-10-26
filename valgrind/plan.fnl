;; valgrind, ported from its plan.sh.
;; valgrind 3.28.0, the latest release on 2026-10-26: 3.12.0's source no longer downloads.
{:name "valgrind"
 :origin "karate"
 :version "3.28.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0"]
 :description "An instrumentation framework for building dynamic analysis tools"
 :upstream_url "http://www.valgrind.org/"
 :source {:url "https://sourceware.org/pub/valgrind/valgrind-3.28.0.tar.bz2" :sha256 "9f7a18d128f05d3a80fea53e6953f34aad7200a425ceaee46099a8a798a7dd9c"}
 :deps ["karate/glibc"]
 :build_deps ["karate/gcc" "karate/make" "karate/which" "karate/diffutils" "karate/perl"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :check (fn [b]
          (b:run ["make" "check"]))
 :strip (fn [b]
          (b:log "Skipping symbol stripping"))}
