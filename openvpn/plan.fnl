;; openvpn, ported from its plan.sh.
{:name :openvpn
 :origin :karate
 :version :2.3.11
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:gplv2]
 :source {:url "https://swupdate.openvpn.org/community/releases/openvpn-2.3.11.tar.gz"
          :sha256 :9117a4434fd35e61cf94f9ee7ef84b7aecbc6fa556f779ff599560f219756163}
 :deps [:karate/glibc :karate/openssl :karate/lzo]
 :build_deps [:karate/gcc
              :karate/coreutils
              :karate/make
              :karate/busybox-static]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :build (fn [b]
          (b:run [:./configure
                  :--disable-plugin-auth-pam
                  (.. :--prefix= b.prefix)
                  (.. :--exec-prefix= b.prefix)
                  (.. :--sbindir= b.prefix :/bin)
                  :--enable-iproute2])
          (b:run [:make]))}
