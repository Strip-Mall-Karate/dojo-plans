;; libsasl2, ported from its plan.sh.
{:name "libsasl2"
 :origin "karate"
 :version "2.1.26"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["custom"]
 :description "Simple Authentication and Security Layer library."
 :upstream_url "https://www.cyrusimap.org/sasl/index.html"
 :source {:url "https://cyrusimap.org/releases/cyrus-sasl-2.1.26.tar.gz" :sha256 "8fbc5136512b59bb793657f36fadda6359cae3b08f01fd16b3d406f1345b7bc3" :dirname "cyrus-sasl-2.1.26"}
 :deps ["karate/glibc" "karate/openssl"]
 :build_deps ["karate/make" "karate/gcc"]
 :bin_dirs ["sbin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :install (fn [b]
          (b.default.install b)
          ;; The plan named $pkgdir, which nothing sets, so the source project's builder
          ;; installed this to /share; the license belongs in the package.
          (b:copy (b:join b.src "COPYING") (.. b.prefix "/share/COPYING"))
          (b:chmod (.. b.prefix "/share/COPYING") "644"))}
