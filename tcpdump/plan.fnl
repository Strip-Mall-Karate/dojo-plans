;; tcpdump, ported from its plan.sh.
{:name "tcpdump"
 :origin "karate"
 :version "4.9.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["BSD"]
 :description "A powerful command-line packet analyzer."
 :upstream_url "http://www.tcpdump.org/"
 :source {:url "http://www.tcpdump.org/release/tcpdump-4.9.2.tar.gz" :sha256 "798b3536a29832ce0cbb07fafb1ce5097c95e308a6f592d14052e1ef1505fe79"}
 :deps ["karate/glibc" "karate/libpcap" "karate/openssl" "karate/coreutils"]
 :build_deps ["karate/gcc" "karate/make" "karate/perl" "karate/diffutils"]
 :bin_dirs ["sbin"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--with-crypto"])
          (b:run ["make" "-j" (tostring b.jobs)]))
 :check (fn [b]
          (b:fix_interpreter [(b:join b.src "tests/TESTonce")] "karate/coreutils" "bin/env")
          (b:run ["make" "check"]))}
