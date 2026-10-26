;; cyrus-sasl, ported from its plan.sh.
{:name "cyrus-sasl"
 :origin "karate"
 :version "2.1.26"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["custom"]
 :description "Cyrus Simple Authentication Service Layer (SASL) library"
 :upstream_url "http://www.cyrusimap.org/"
 :source {:url "https://www.cyrusimap.org/releases/cyrus-sasl-2.1.26.tar.gz" :sha256 "8fbc5136512b59bb793657f36fadda6359cae3b08f01fd16b3d406f1345b7bc3"}
 :deps ["karate/glibc" "karate/openssl"]
 :build_deps ["karate/gcc" "karate/make"]
 :bin_dirs ["sbin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) (.. "--with-plugindir=" b.prefix "/lib/sasl2") "--enable-auth-sasldb" "--with-saslauthd=/doj/svc/cyrus-sasl/var/run/saslauthd"])
          (b:run ["make"]))
 :install (fn [b]
          (b:run ["make" "install"])
          (b:copy (b:join b.src "COPYING") (b:join (.. b.prefix "/share/") (: (b:join b.src "COPYING") :match "[^/]+$")))
          (b:chmod (b:join (.. b.prefix "/share/") (: (b:join b.src "COPYING") :match "[^/]+$")) "644"))}
