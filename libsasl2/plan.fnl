;; libsasl2, ported from its plan.sh.
;; libsasl2 2.1.28, the latest release on 2026-10-26: 2.1.26's source no longer downloads.
{:name :libsasl2
 :origin :karate
 :version :2.1.28
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:custom]
 :description "Simple Authentication and Security Layer library."
 :upstream_url "https://www.cyrusimap.org/sasl/index.html"
 :source {:url "https://github.com/cyrusimap/cyrus-sasl/releases/download/cyrus-sasl-2.1.28/cyrus-sasl-2.1.28.tar.gz"
          :sha256 :7ccfc6abd01ed67c1a0924b353e526f1b766b21f42d4562ee635a8ebfc5bb38c
          :dirname :cyrus-sasl-2.1.28}
 :deps [:karate/glibc :karate/openssl]
 :build_deps [:karate/make :karate/gcc]
 :bin_dirs [:sbin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]
 :install (fn [b]
            (b.default.install b)
            ;; The plan named $pkgdir, which nothing sets, so the source project's builder
            ;; installed this to /share; the license belongs in the package.
            (b:copy (b:join b.src :COPYING) (.. b.prefix :/share/COPYING))
            (b:chmod (.. b.prefix :/share/COPYING) :644))}
