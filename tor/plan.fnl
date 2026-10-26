;; tor, ported from its plan.sh.
;; tor 0.4.9.14, the latest release on 2026-10-26: 0.3.3.6's source no longer downloads.
{:name "tor"
 :origin "karate"
 :version "0.4.9.14"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["BSD-3-Clause"]
 :description "Free software and an open network that helps you defend against traffic analysis"
 :upstream_url "https://www.torproject.org/"
 :source {:url "https://dist.torproject.org/tor-0.4.9.14.tar.gz" :sha256 "182449ac1c8ff43278da27b69b02040e11d03d0327db6d9126e4190ec6235e4a"}
 :deps ["karate/glibc" "karate/gcc-libs" "karate/libevent" "karate/openssl" "karate/zlib" "karate/libseccomp" "karate/libscrypt"]
 :build_deps ["karate/gcc" "karate/make" "karate/pkg-config" "karate/python"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :svc {:run "tor -f /doj/svc/tor/config/torrc"}
 :exports {"port" "socks_bind_port"}
 :exposes ["port"]
 :build (fn [b]
          (b:env "CFLAGS" (.. "-O2 " (or (b:getenv "CFLAGS") "")))
          (b:env "LDFLAGS" (.. "-lgcc_s " (or (b:getenv "LDFLAGS") "")))
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--disable-dependency-tracking"])
          (b:run ["make"]))
 :check (fn [b]
          (b:run ["make" "test"]))}
