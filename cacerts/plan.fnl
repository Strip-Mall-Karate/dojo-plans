;; cacerts, ported from its plan.sh.
;; cacerts 2026.10.20, the latest release on 2026-10-26.
{:name :cacerts
 :origin :karate
 :maintainer "Strip Mall Karate Company"
 :targets [:x86_64-linux]
 :license [:MPL-2.0]
 :description "The Mozilla CA certificate store in PEM format (around 250KB uncompressed)."
 :upstream_url "https://curl.haxx.se/docs/caextract.html"
 :version :2026.10.20
 :source {:url "https://curl.se/ca/cacert-2026-10-20.pem"
          :sha256 :796f1389bfea13c0ed78f663b765baaff54a508e5483786bd6ece73c5e3e3cbe
          :filename :cacert.pem}
 :unpack (fn [b]
           (b:mkdir (.. b.cache "/" (.. b.name "-" b.version)))
           (if (b:exists (.. b.cache "/" (.. b.name "-" b.version)))
               (b:copy (.. b.cache :/cacert.pem)
                       (b:join (.. b.cache "/" (.. b.name "-" b.version))
                               (: (.. b.cache :/cacert.pem) :match "[^/]+$")))
               (b:copy (.. b.cache :/cacert.pem)
                       (.. b.cache "/" (.. b.name "-" b.version)))))
 :build (fn [b]
          nil)
 :install (fn [b]
            (b:mkdir (.. b.prefix :/ssl/certs))
            (if (b:exists (.. b.prefix :/ssl/certs))
                (b:copy (b:join b.src :cacert.pem)
                        (b:join (.. b.prefix :/ssl/certs)
                                (: (b:join b.src :cacert.pem) :match "[^/]+$")))
                (b:copy (b:join b.src :cacert.pem) (.. b.prefix :/ssl/certs)))
            (b:symlink :certs/cacert.pem (.. b.prefix :/ssl/cert.pem)))}
