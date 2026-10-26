;; lttng-ust, ported from its plan.sh.
{:name "lttng-ust"
 :origin "karate"
 :version "2.8.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0" "MIT"]
 :description "LTTng is an open source tracing framework for Linux."
 :upstream_url "http://lttng.org/"
 :source {:url "http://lttng.org//files/lttng-ust/lttng-ust-2.8.1.tar.bz2" :sha256 "6e41349107e83e7b43c69ed358e48788ca2fd095bad61737b850e3f3d2c0508a"}
 :deps ["karate/coreutils" "karate/gcc-libs" "karate/glibc" "karate/python2" "karate/userspace-rcu"]
 :build_deps ["karate/gcc" "karate/make"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :prepare (fn [b]
          (b:fix_interpreter [(.. b.cache "/" (.. b.name "-" b.version) "/tools/lttng-gen-tp")] "karate/coreutils" "bin/env"))}
