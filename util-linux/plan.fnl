;; util-linux, ported from its plan.sh.
;; util-linux 2.42.4, the latest release on 2026-10-26.
{:name :util-linux
 :origin :karate
 :version :2.42.4
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPLv2]
 :description "Miscellaneous system utilities for Linux"
 :upstream_url "https://www.kernel.org/pub/linux/utils/util-linux"
 :source {:url "https://www.kernel.org/pub/linux/utils/util-linux/v2.42/util-linux-2.42.4.tar.xz"
          :sha256 :fbd62a100ab7bb8746ba0661255c3c48185b1e9021507c624da01fbc696330ec}
 :deps [:karate/glibc :karate/zlib :karate/ncurses]
 :build_deps [:karate/coreutils
              :karate/diffutils
              :karate/patch
              :karate/make
              :karate/gcc
              :karate/sed]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]
 :build (fn [b]
          (b:run [:./configure
                  (.. :--prefix= b.prefix)
                  (.. :--sbindir= b.prefix :/bin)
                  :--localstatedir=/doj/svc/util-linux/var/run
                  :--without-python
                  :--without-slang
                  :--without-systemd
                  :--without-systemdsystemunitdir
                  :--disable-use-tty-group
                  :--disable-chfn-chsh
                  :--disable-login
                  :--disable-nologin
                  :--disable-su
                  :--disable-setpriv
                  :--disable-runuser
                  :--disable-pylibmount
                  :--disable-makeinstall-chown
                  :--disable-makeinstall-setuid])
          (b:run [:make]))
 :install (fn [b]
            (b:run [:make :install (.. :usrsbin_execdir= b.prefix :/bin)]))}
