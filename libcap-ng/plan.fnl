;; libcap-ng, ported from its plan.sh.
{:name "libcap-ng"
 :origin "karate"
 :version "0.7.8"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0" "LGPL-2.1"]
 :description "The libcap-ng library is intended to make programming with posix capabilities much easier than the traditional libcap library"
 :upstream_url "https://people.redhat.com/sgrubb/libcap-ng/"
 :source {:url "http://people.redhat.com/sgrubb/libcap-ng/libcap-ng-0.7.8.tar.gz" :sha256 "c21af997445cd4107a55d386f955c5ea6f6e96ead693e9151277c0ab5f97d05f"}
 :deps ["karate/glibc"]
 :build_deps ["karate/make" "karate/gcc"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--enable-static=no" "--with-python=no"])
          (b:run ["make"]))}
