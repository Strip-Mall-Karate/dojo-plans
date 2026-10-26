;; jemalloc, ported from its plan.sh.
{:name "jemalloc"
 :origin "karate"
 :version "4.3.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["BSD-2-Clause"]
 :description "malloc implementation emphasizing fragmentation avoidance"
 :upstream_url "http://jemalloc.net/"
 :source {:url "https://github.com/jemalloc/jemalloc/releases/download/4.3.1/jemalloc-4.3.1.tar.bz2" :sha256 "f7bb183ad8056941791e0f075b802e8ff10bd6e2d904e682f87c8f6a510c278b" :dirname "jemalloc-4.3.1"}
 :deps ["karate/glibc"]
 :build_deps ["karate/gcc" "karate/make"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :check (fn [b]
          (b:run ["make" "check"]))
 :install (fn [b]
          (b:run ["make" "install_bin" "install_include" "install_lib"])
          (b:copy (b:join b.src "COPYING") (.. b.prefix "/share/licenses/license.txt"))
          (b:chmod (.. b.prefix "/share/licenses/license.txt") "644"))}
