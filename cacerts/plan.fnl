;; cacerts, ported from its plan.sh.
;; The source project's plan took the newest bundle and its date as the version,
;; unverified. This is the bundle current on 10 April 2019, the fork date, pinned.
{:name "cacerts"
 :origin "karate"
 :maintainer "Strip Mall Karate Company"
 :targets ["x86_64-linux"]
 :license ["MPL-2.0"]
 :description "The Mozilla CA certificate store in PEM format (around 250KB uncompressed)."
 :upstream_url "https://curl.haxx.se/docs/caextract.html"
 :version "2019.01.23"
 :source {:url "https://curl.se/ca/cacert-2019-01-23.pem" :sha256 "c1fd9b235896b1094ee97bfb7e042f93530b5e300781f59b45edf84ee8c75000" :filename "cacert.pem"}
 :unpack (fn [b]
          (b:mkdir (.. b.cache "/" (.. b.name "-" b.version)))
          (if (b:exists (.. b.cache "/" (.. b.name "-" b.version)))
            (b:copy (.. b.cache "/cacert.pem") (b:join (.. b.cache "/" (.. b.name "-" b.version)) (: (.. b.cache "/cacert.pem") :match "[^/]+$")))
            (b:copy (.. b.cache "/cacert.pem") (.. b.cache "/" (.. b.name "-" b.version)))))
 :build (fn [b]
          nil)
 :install (fn [b]
          (b:mkdir (.. b.prefix "/ssl/certs"))
          (if (b:exists (.. b.prefix "/ssl/certs"))
            (b:copy (b:join b.src "cacert.pem") (b:join (.. b.prefix "/ssl/certs") (: (b:join b.src "cacert.pem") :match "[^/]+$")))
            (b:copy (b:join b.src "cacert.pem") (.. b.prefix "/ssl/certs")))
          (b:symlink "certs/cacert.pem" (.. b.prefix "/ssl/cert.pem")))}
