;; libpcap, ported from its plan.sh.
{:name "libpcap"
 :origin "karate"
 :version "1.8.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["BSD"]
 :description "A portable C/C++ library for network traffic capture."
 :upstream_url "http://www.tcpdump.org/"
 :source {:url "http://www.tcpdump.org/release/libpcap-1.8.1.tar.gz" :sha256 "673dbc69fdc3f5a86fb5759ab19899039a8e5e6c631749e48dcd9c6f0c83541e"}
 :deps ["karate/glibc"]
 :build_deps ["karate/gcc" "karate/make" "karate/flex" "karate/bison" "karate/m4"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--with-pcap=linux"])
          (b:run ["make" "-j" (tostring b.jobs)]))
 :check (fn [b]
          (b:run ["make" "tests"]))}
