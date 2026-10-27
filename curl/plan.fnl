;; curl, ported from its plan.sh.
;; curl 8.23.0, the latest release on 2026-10-27: 7.63.0 does not build against OpenSSL 4.
{:name "curl"
 :origin "karate"
 :version "8.23.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["curl"]
 :description "curl is an open source command line tool and library for\ntransferring data with URL syntax."
 :upstream_url "https://curl.se/"
 :source {:url "https://curl.se/download/curl-8.23.0.tar.xz" :sha256 "8dadd7d2536a314f982ad05a651b713f426bf7d02cc2c76cffb9796f2218e6c5"}
 :deps ["karate/cacerts" "karate/glibc" "karate/openssl" "karate/zlib" "karate/nghttp2"]
 :build_deps ["karate/coreutils" "karate/gcc" "karate/make" "karate/perl" "karate/pkg-config"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix)
                  (.. "--with-ca-bundle=" (b:path_for "cacerts") "/ssl/certs/cacert.pem")
                  (.. "--with-openssl=" (b:path_for "openssl"))
                  (.. "--with-zlib=" (b:path_for "zlib"))
                  (.. "--with-nghttp2=" (b:path_for "nghttp2"))
                  "--disable-manual" "--disable-ldap" "--disable-ldaps" "--disable-rtsp"
                  "--enable-proxy" "--enable-optimize" "--disable-dependency-tracking" "--enable-ipv6"
                  "--without-libidn2" "--without-libpsl" "--without-librtmp"])
          (b:run ["make" (.. "-j" (tostring b.jobs))]))}
