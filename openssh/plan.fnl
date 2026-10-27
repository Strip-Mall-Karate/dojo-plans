;; openssh, ported from its plan.sh.
;; OpenSSH 10.6p1, the latest release on 2026-10-27: 7.5p1 does not build against OpenSSL 4.
{:name :openssh
 :origin :karate
 :version :10.6p1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:bsd]
 :description "Provides OpenSSH client and server."
 :upstream_url "https://www.openssh.com/"
 :source {:url "https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-10.6p1.tar.gz"
          :sha256 :a9dc9565dffe8640f64d863cd29a32bc4a3dbdec0566a7fc44c5d6ee767d5f39}
 :deps [:karate/glibc :karate/libxcrypt :karate/openssl :karate/zlib]
 :build_deps [:karate/coreutils :karate/gcc :karate/make]
 :bin_dirs [:bin :sbin :libexec]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :svc {:user :root :group :root}
 :build (fn [b]
          (b:run [:./configure
                  (.. :--prefix= b.prefix)
                  :--sysconfdir=/doj/svc/openssh/config
                  :--localstatedir=/doj/svc/openssh/var
                  :--datadir=/doj/svc/openssh/data
                  :--with-privsep-user=doj
                  (.. :--with-privsep-path= b.prefix :/var/empty)])
          (b:run [:make (.. :-j (tostring b.jobs))]))
 :install (fn [b]
            (b:run [:make :install-nosysconf])
            (b:mkdir (.. b.prefix :/var/empty))
            (b:chmod (.. b.prefix :/var/empty) :700))}
