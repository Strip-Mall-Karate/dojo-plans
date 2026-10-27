;; dbus, ported from its plan.sh.
{:name :dbus
 :origin :karate
 :version :1.13.8
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPLv2]
 :description "D-Bus is a message bus system, a simple way for applications to talk to one another."
 :upstream_url "https://www.freedesktop.org/wiki/Software/dbus/"
 :source {:url "https://dbus.freedesktop.org/releases/dbus/dbus-1.13.8.tar.xz"
          :sha256 :82a89f64e1b55e459725186467770995f33cac5eb8a050b5d8cbeb338078c4f6}
 :deps [:karate/glibc]
 :build_deps [:karate/autoconf
              :karate/automake
              :karate/make
              :karate/expat
              :karate/gcc
              :karate/pkg-config]
 :bin_dirs [:bin]
 :lib_dirs [:lib]}
