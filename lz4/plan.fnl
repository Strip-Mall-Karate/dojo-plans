;; lz4, ported from its plan.sh.
{:name "lz4"
 :origin "karate"
 :version "1.8.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["BSD-2 Clause" "GPL-2.0"]
 :description "Extremely Fast Compression algorithm http://www.lz4.org"
 :upstream_url "http://lz4.github.io/lz4/"
 :source {:url "https://github.com/lz4/lz4/archive/v1.8.0.tar.gz" :sha256 "2ca482ea7a9bb103603108b5a7510b7592b90158c151ff50a28f1ca8389fccf6"}
 :deps ["karate/glibc"]
 :build_deps ["karate/gcc" "karate/make" "karate/diffutils" "karate/valgrind"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["make" (.. "PREFIX=" b.prefix)]))
 :check (fn [b]
          (b:run ["make" "test"]))}
