;; openssl-fips, ported from its plan.sh.
{:name "openssl-fips"
 :origin "karate"
 :version "2.0.16"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["OpenSSL"]
 :description "The OpenSSL FIPS Object Module v2.0 provide cryptographic services to external applications. The FIPS Object Module provides an API for invocation of FIPS approved cryptographic functions from calling applications, and is designed for use in conjunction with standard OpenSSL 1.0.1 and 1.0.2 distributions."
 :upstream_url "https://www.openssl.org"
 :source {:url "https://www.openssl.org/source/openssl-fips-2.0.16.tar.gz" :sha256 "a3cd13d0521d22dd939063d3b4a0d4ce24494374b91408a05bdaca8b681c63d4" :filename "openssl-fips-2.0.16.tar.gz"}
 :deps ["karate/glibc"]
 :build_deps ["karate/make" "karate/perl" "karate/gcc"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["./config"] {:cwd (.. b.cache "/" b.name "-" b.version)})
          (b:run ["make"] {:cwd (.. b.cache "/" b.name "-" b.version)}))
 :install (fn [b]
          (b:run ["make" (.. "INSTALLTOP=" b.prefix) "install"] {:cwd (.. b.cache "/" b.name "-" b.version)}))}
