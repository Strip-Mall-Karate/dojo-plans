;; numactl, ported from its plan.sh.
{:name "numactl"
 :origin "karate"
 :version "2.0.9"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0" "LGPL-2.1"]
 :description "NUMA support for Linux http://oss.sgi.com/projects/libnuma/"
 :upstream_url "https://github.com/numactl/numactl"
 :source {:url "https://github.com/numactl/numactl/archive/v2.0.9.tar.gz" :sha256 "3e893f41e601eac3100eefd659dbead8c75a89b9b73bc01c8387966181d9320c"}
 :deps ["karate/glibc"]
 :build_deps ["karate/gcc" "karate/make"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib64"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["make" (.. "PREFIX=" b.prefix)]))}
