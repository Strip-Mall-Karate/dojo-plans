;; libaio, ported from its plan.sh.
;; libaio 0.3.113, the latest release on 2026-10-26: 0.3.109's source no longer downloads.
{:name :libaio
 :origin :karate
 :version :0.3.113
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:LGPL]
 :source {:url "https://deb.debian.org/debian/pool/main/liba/libaio/libaio_0.3.113.orig.tar.gz"
          :sha256 :2c44d1c5fd0d43752287c9ae1eb9c023f04ef848ea8d4aafa46e9aedb678200b
          :filename :libaio-0.3.113.tar.gz}
 :build_deps [:karate/coreutils :karate/gcc :karate/make]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :build (fn [b]
          (b:run [:make]))
 :install (fn [b]
            (b:run [:make :install (.. :prefix= b.prefix)]))}
