;; geoip, ported from its plan.sh.
;; UNPORTED: do_install: pipeline or list
{:name "geoip"
 :origin "karate"
 :version "1.6.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["LGPL-2.1"]
 :description "GeoIP Legacy C API"
 :upstream_url "https://github.com/maxmind/geoip-api-c"
 :source {:url "https://github.com/maxmind/geoip-api-c/releases/download/v1.6.0/GeoIP-1.6.0.tar.gz" :sha256 "443f46b89c3d626ae81463c2aac98300fff1e3b674faf06070843fbefedcf710" :dirname "GeoIP-1.6.0"}
 :deps ["karate/glibc"]
 :build_deps ["karate/gcc" "karate/make" "karate/diffutils" "karate/curl" "karate/gzip"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :install (fn [b]
          (b.default.install b)
          (b:log "Downloading GeoIP.dat")
          (b:mkdir (.. b.prefix "/share/GeoIP"))
          ;; UNPORTED (pipeline or list):
          ;;   curl "http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz" | gunzip > "${pkg_prefix}/share/GeoIP/GeoIP.dat"
          (b:write (.. b.prefix "/GEOIP_LICENSE") "This product includes GeoLite data created by MaxMind, available from [http://www.maxmind.com](http://www.maxmind.com).\n"))}
