;; libice, ported from its plan.sh.
{:name :libice
 :origin :karate
 :version :1.0.9
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "X11 Inter-Client Exchange library"
 :upstream_url "https://www.x.org/"
 :source {:url "https://www.x.org/releases/individual/lib/libICE-1.0.9.tar.bz2"
          :sha256 :8f7032f2c1c64352b5423f6b48a8ebdc339cc63064af34d66a6c9aa79759e202
          :dirname :libICE-1.0.9}
 :deps [:karate/glibc]
 :build_deps [:karate/gcc
              :karate/make
              :karate/pkg-config
              :karate/xproto
              :karate/xtrans]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]
 :check (fn [b]
          (b:run [:make :check]))}
