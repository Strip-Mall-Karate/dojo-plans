;; libseccomp, ported from its plan.sh.
{:name "libseccomp"
 :origin "karate"
 :version "2.3.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["LGPL-2.1"]
 :description "An easy to use, platform independent, interface\nto the Linux Kernel's syscall filtering mechanism."
 :upstream_url "https://github.com/seccomp/libseccomp"
 :source {:url "https://github.com/seccomp/libseccomp/releases/download/v2.3.1/libseccomp-2.3.1.tar.gz" :sha256 "ff5bdd2168790f1979e24eaa498f8606c2f2d96f08a8dc4006a2e88affa4562b"}
 :deps ["karate/glibc"]
 :build_deps ["karate/gcc" "karate/make" "karate/diffutils"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]}
