;; scons, ported from its plan.sh.
{:name :scons
 :origin :karate
 :version :2.5.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "Substitute for classic 'make' tool with autoconf/automake functionality"
 :upstream_url "http://www.scons.org/"
 :source {:url "https://downloads.sourceforge.net/project/scons/scons/2.5.1/scons-2.5.1.tar.gz"
          :sha256 :0b25218ae7b46a967db42f2a53721645b3d42874a65f9552ad16ce26d30f51f2}
 :deps [:karate/coreutils :karate/python2]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :build (fn [b]
          nil)
 :install (fn [b]
            (b:run [:python
                    :setup.py
                    :install
                    (.. :--prefix= b.prefix)
                    :--no-version-script
                    :--no-install-bat
                    :--no-install-man])
            (each [_ v-binary (ipairs [:scons :scons-time :sconsign])]
              (b:fix_interpreter [(.. b.prefix :/bin/ v-binary)]
                                 :karate/coreutils :bin/env)))}
