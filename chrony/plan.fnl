;; chrony, ported from its plan.sh.
{:name "chrony"
 :origin "karate"
 :version "3.4"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0"]
 :description "Chrony is a versatile implementation of the Network Time Protocol (NTP)."
 :upstream_url "https://chrony.tuxfamily.org/"
 :source {:url "https://download.tuxfamily.org/chrony/chrony-3.4.tar.gz" :sha256 "af77e47c2610a7e55c8af5b89a8aeff52d9a867dd5983d848b52d374bc0e6b9f"}
 :deps ["karate/glibc" "karate/nss" "karate/readline" "karate/libcap" "karate/libedit" "karate/libseccomp" "karate/nettle"]
 :build_deps ["karate/gcc" "karate/make"]
 :bin_dirs ["bin" "sbin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :svc {:user "root" :group "root"}
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--enable-scfilter" "--enable-ntp-signd"])
          (b:run ["make"]))}
