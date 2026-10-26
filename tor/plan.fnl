;; tor, ported from its plan.sh.
{:name "tor"
 :origin "karate"
 :version "0.3.3.6"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["BSD-3-Clause"]
 :description "Free software and an open network that helps you defend against traffic analysis"
 :upstream_url "https://www.torproject.org/"
 :source {:url "https://www.torproject.org/dist/tor-0.3.3.6.tar.gz" :sha256 "99bc59f6dbf395894de12f3a83b3251a82dfd93dc7f6d3afcbbd80f6111433b7"}
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
