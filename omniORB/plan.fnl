;; omniORB, ported from its plan.sh.
{:name :omniORB
 :origin :karate
 :version :4.2.2
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:LGPL-2.0 :GPL-2.0]
 :description "A CORBA object request broker for C++ and Python."
 :upstream_url "http://omniorb.sourceforge.net"
 :source {:url "https://downloads.sourceforge.net/omniorb/omniORB-4.2.2.tar.bz2"
          :sha256 :ddd909ce31014be2beebf67a5e9fabbf03b5bb0c26b8c53ab64d470d77348ece}
 :deps [:karate/coreutils :karate/gcc-libs :karate/glibc]
 :build_deps [:karate/autoconf
              :karate/gcc
              :karate/glib
              :karate/make
              :karate/openssl
              :karate/pkg-config
              :karate/python2]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]
 :install (fn [b]
            (b.default.install b)
            (b:log "Fixing interpreters")
            (b:fix_interpreter [(.. b.prefix :/bin/omniidlrun.py)]
                               :karate/coreutils :bin/env))}
