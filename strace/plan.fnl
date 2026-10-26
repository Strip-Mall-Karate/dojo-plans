;; strace, ported from its plan.sh.
{:name "strace"
 :origin "karate"
 :version "5.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["LGPL-2.1-or-later"]
 :description "strace is a system call tracer for Linux"
 :upstream_url "https://strace.io/"
 :source {:url "https://github.com/strace/strace/releases/download/v5.0/strace-5.0.tar.xz" :sha256 "3b7ad77eb2b81dc6078046a9cc56eed5242b67b63748e7fc28f7c2daf4e647da"}
 :deps ["karate/glibc" "karate/libunwind"]
 :build_deps ["karate/coreutils" "karate/make" "karate/gcc" "karate/diffutils"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :check (fn [b]
          (b:run ["make" "check"]))}
