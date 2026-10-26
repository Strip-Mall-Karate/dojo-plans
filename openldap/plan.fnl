;; openldap, ported from its plan.sh.
{:name "openldap"
 :origin "karate"
 :version "2.4.46"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["OLDAP-2.8"]
 :description "Community developed LDAP software"
 :upstream_url "http://www.openldap.org/"
 :source {:url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.4.46.tgz" :sha256 "9a90dcb86b99ae790ccab93b7585a31fbcbeec8c94bf0f7ab0ca0a87ea0c4b2d"}
 :deps ["karate/glibc" "karate/libtool" "karate/db" "karate/openssl" "karate/cyrus-sasl"]
 :build_deps ["karate/gcc" "karate/make" "karate/groff"]
 :bin_dirs ["bin" "sbin" "libexec"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :exports {"port" "port"}
 :exposes ["port"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--localstatedir=/doj/svc/openldap/var" "--enable-dynamic" "--enable-local" "--enable-proctitle" "--enable-shared" "--enable-ipv6" "--enable-slapd" "--enable-crypt" "--enable-modules" "--enable-rewrite" "--enable-rlookups" "--enable-bdb" "--enable-hdb" "--enable-syncprov=yes" "--enable-overlays=mod" "--with-tls=openssl" "--with-cyrus-sasl"])
          (b:run ["make" "depend"])
          (b:run ["make"]))
 :check (fn [b]
          (b:run ["make" "test"]))}
