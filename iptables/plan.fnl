;; iptables, ported from its plan.sh.
{:name "iptables"
 :origin "karate"
 :version "1.6.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["gplv2"]
 :source {:url "http://netfilter.org/projects/iptables/files/iptables-1.6.0.tar.bz2" :sha256 "4bb72a0a0b18b5a9e79e87631ddc4084528e5df236bc7624472dcaa8480f1c60"}
 :deps ["karate/glibc"]
 :build_deps ["karate/make" "karate/gcc" "karate/bison" "karate/flex"]
 :bin_dirs ["bin" "sbin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--enable-devel" "--disable-static" "--enable-shared" "--enable-libipq" "--disable-nftables" (.. "--with-xtlibdir=" b.prefix "/lib/xtlibs")])
          (b:run ["make"]))}
