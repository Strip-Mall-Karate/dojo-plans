;; libmd 1.3.0, the latest release on 2026-10-26. Written for Dojo: libbsd 0.10 and later take
;; their message digest functions from it.
{:name :libmd
 :origin :karate
 :version :1.3.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:BSD-3-Clause :BSD-2-Clause :ISC :Beerware :Public-Domain]
 :description "Message digest functions from BSD systems: MD2, MD4, MD5, RIPEMD-160, SHA-1 and SHA-2."
 :upstream_url "https://www.hadrons.org/software/libmd/"
 :source {:url "https://libbsd.freedesktop.org/releases/libmd-1.3.0.tar.xz"
          :sha256 :fc0f1eb6b6766470326f2c014693809190e67dba84274a6fbae9d4912d066706}
 :deps [:karate/glibc]
 :build_deps [:karate/coreutils :karate/diffutils :karate/make :karate/gcc]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]
 :build (fn [b]
          (b:run [:./configure (.. :--prefix= b.prefix)])
          (b:run [:make (.. :-j (tostring b.jobs))]))
 :check (fn [b]
          (b:run [:make :check]))}
