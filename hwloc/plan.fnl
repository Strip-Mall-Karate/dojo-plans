;; hwloc, ported from its plan.sh.
{:name "hwloc"
 :origin "karate"
 :version "2.0.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["BSD-2-Clause"]
 :description "Portable Hardware Locality"
 :upstream_url "https://www.open-mpi.org/software/hwloc"
 :source {:url "https://www.open-mpi.org/software/hwloc/v2.0/downloads/hwloc-2.0.1.tar.gz" :sha256 "f1156df22fc2365a31a3dc5f752c53aad49e34a5e22d75ed231cd97eaa437f9d"}
 :deps ["karate/glibc" "karate/gcc-libs"]
 :build_deps ["karate/gcc" "karate/make" "karate/diffutils"]
 :bin_dirs ["bin" "sbin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :check (fn [b]
          (b:run ["make" "check"]))}
