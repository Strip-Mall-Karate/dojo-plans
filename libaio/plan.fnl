;; libaio, ported from its plan.sh.
{:name "libaio"
 :origin "karate"
 :version "0.3.109"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["LGPL"]
 :source {:url "http://ftp.de.debian.org/debian/pool/main/liba/libaio/libaio_0.3.109.orig.tar.gz" :sha256 "bf4a457253cbaab215aea75cb6e18dc8d95bbd507e9920661ff9bdd288c8778d" :filename "libaio-0.3.109.tar.gz"}
 :build_deps ["karate/coreutils" "karate/gcc" "karate/make"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["make"]))
 :install (fn [b]
          (b:run ["make" "install" (.. "prefix=" b.prefix)]))}
