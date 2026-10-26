;; cyrus-sasl, ported from its plan.sh.
;; cyrus-sasl 2.1.28, the latest release on 2026-10-26: 2.1.26's source no longer downloads.
{:name "cyrus-sasl"
 :origin "karate"
 :version "2.1.28"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["custom"]
 :description "Cyrus Simple Authentication Service Layer (SASL) library"
 :upstream_url "http://www.cyrusimap.org/"
 :source {:url "https://github.com/cyrusimap/cyrus-sasl/releases/download/cyrus-sasl-2.1.28/cyrus-sasl-2.1.28.tar.gz" :sha256 "7ccfc6abd01ed67c1a0924b353e526f1b766b21f42d4562ee635a8ebfc5bb38c"}
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
