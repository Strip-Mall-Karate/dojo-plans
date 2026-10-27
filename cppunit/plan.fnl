;; cppunit, ported from its plan.sh.
{:name :cppunit
 :origin :karate
 :version :1.14.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:LGPL-2.1]
 :description "CppUnit is the C++ port of the famous JUnit framework for unit testing. Test output is in XML for automatic testing and GUI based for supervised tests."
 :upstream_url "https://www.freedesktop.org/wiki/Software/cppunit/"
 :source {:url "http://dev-www.libreoffice.org/src/cppunit-1.14.0.tar.gz"
          :sha256 :3d569869d27b48860210c758c4f313082103a5e58219a7669b52bfd29d674780}
 :deps [:karate/bash :karate/gcc-libs]
 :build_deps [:karate/autoconf
              :karate/automake
              :karate/gcc
              :karate/glib
              :karate/libtool
              :karate/make
              :karate/pkg-config
              :karate/which]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]
 :prepare (fn [b]
            (b:log "Fixing 'bin/env' interpreter for autogen.sh")
            (b:fix_interpreter [(.. b.cache "/" (.. b.name "-" b.version)
                                    :/autogen.sh)]
                               :karate/bash :bin/sh))
 :build (fn [b]
          (b:run [:./autogen.sh])
          (b:run [:./configure (.. :--prefix= b.prefix)])
          (b:run [:make]))
 :check (fn [b]
          (b:run [:make :check]))}
