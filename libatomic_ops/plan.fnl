;; libatomic_ops, ported from its plan.sh.
{:name "libatomic_ops"
 :origin "karate"
 :version "7.4.4"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0"]
 :description "Atomic memory update operations"
 :upstream_url "https://github.com/ivmai/libatomic_ops"
 :source {:url "http://www.ivmaisoft.com/_bin/atomic_ops/libatomic_ops-7.4.4.tar.gz" :sha256 "bf210a600dd1becbf7936dd2914cf5f5d3356046904848dcfd27d0c8b12b6f8f"}
 :deps ["karate/glibc"]
 :build_deps ["karate/gcc" "karate/make" "karate/diffutils"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :check (fn [b]
          (b:run ["make" "check"]))}
