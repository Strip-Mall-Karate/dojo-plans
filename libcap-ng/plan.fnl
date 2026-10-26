;; libcap-ng, ported from its plan.sh.
;; libcap-ng 0.8.5, the latest release on 2026-10-26: 0.7.8's source no longer downloads.
{:name "libcap-ng"
 :origin "karate"
 :version "0.8.5"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0" "LGPL-2.1"]
 :description "The libcap-ng library is intended to make programming with posix capabilities much easier than the traditional libcap library"
 :upstream_url "https://people.redhat.com/sgrubb/libcap-ng/"
 :source {:url "https://people.redhat.com/sgrubb/libcap-ng/libcap-ng-0.8.5.tar.gz" :sha256 "3ba5294d1cbdfa98afaacfbc00b6af9ed2b83e8a21817185dfd844cc8c7ac6ff"}
 :deps ["karate/glibc"]
 :build_deps ["karate/make" "karate/gcc"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--enable-static=no" "--with-python=no"])
          (b:run ["make"]))}
