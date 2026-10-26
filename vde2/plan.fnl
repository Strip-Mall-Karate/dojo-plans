;; vde2, ported from its plan.sh.
{:name "vde2"
 :origin "karate"
 :version "2.3.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0"]
 :description "VDE is an ethernet compliant virtual network that can be spawned over a set of physical computer over the Internet."
 :upstream_url "http://vde.sourceforge.net/"
 :source {:url "http://downloads.sourceforge.net/vde/vde2-2.3.2.tar.bz2" :sha256 "cbea9b7e03097f87a6b5e98b07890d2275848f1fe4b9fcda77b8994148bc9542"}
 :deps ["karate/bash" "karate/glibc" "karate/gcc-libs" "karate/libpcap" "karate/openssl"]
 :build_deps ["karate/make" "karate/gcc" "karate/gcc-libs" "karate/glibc" "karate/python2"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--enable-experimental"])
          (b:run ["make"]))}
