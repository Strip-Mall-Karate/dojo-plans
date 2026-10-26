;; userspace-rcu, ported from its plan.sh.
{:name "userspace-rcu"
 :origin "karate"
 :version "0.9.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["LGPL-2.1"]
 :description "liburcu is a LGPLv2.1 userspace RCU (read-copy-update) library.\nThis data synchronization library provides read-side access which scales\nlinearly with the number of cores."
 :upstream_url "http://liburcu.org/"
 :source {:url "http://www.lttng.org/files/urcu/userspace-rcu-0.9.2.tar.bz2" :sha256 "8f7fa313b1e0a3f742cea24ce63a39c0efe63e615a769e2961e55bd2663ecaa3"}
 :deps ["karate/gcc-libs" "karate/glibc"]
 :build_deps ["karate/gcc" "karate/make"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]}
