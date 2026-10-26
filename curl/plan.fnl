;; curl, ported from its plan.sh.
{:name "curl"
 :origin "karate"
 :version "7.63.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["curl"]
 :description "curl is an open source command line tool and library for\ntransferring data with URL syntax."
 :upstream_url "https://curl.haxx.se/"
 :source {:url "https://curl.haxx.se/download/curl-7.63.0.tar.gz" :sha256 "d483b89062832e211c887d7cf1b65c902d591b48c11fe7d174af781681580b41"}
 :deps ["karate/cacerts" "karate/glibc" "karate/openssl" "karate/zlib" "karate/nghttp2"]
 :build_deps ["karate/coreutils" "karate/gcc" "karate/make" "karate/perl" "karate/pkg-config"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :prepare (fn [b]
          (let [text (b:read (b:join b.src "scripts/zsh.pl"))] (b:write (b:join b.src "scripts/zsh.pl") (pick-values 1 (string.gsub text "[^\n]+" (fn [l] (var line l) (set line (pick-values 1 (string.gsub line "/usr/bin/perl" (.. (pick-values 1 (: (b:path_for "perl") :gsub "%%" "%%%%")) "/bin/perl")))) line))))))
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) (.. "--with-ca-bundle=" (b:path_for "cacerts") "/ssl/certs/cacert.pem") (.. "--with-ssl=" (b:path_for "openssl")) (.. "--with-zlib=" (b:path_for "zlib")) (.. "--with-nghttp2=" (b:path_for "nghttp2")) "--disable-manual" "--disable-ldap" "--disable-ldaps" "--disable-rtsp" "--enable-proxy" "--enable-optimize" "--disable-dependency-tracking" "--enable-ipv6" "--without-libidn" "--without-gnutls" "--without-librtmp"])
          (b:run ["make"]))}
