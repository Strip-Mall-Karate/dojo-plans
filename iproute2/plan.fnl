;; iproute2, ported from its plan.sh.
{:name :iproute2
 :origin :karate
 :version :4.16.0
 :targets [:x86_64-linux :x86_64-linux-kernel2]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-2.0]
 :description "Collection of utilities for controlling TCP/IP networking"
 :upstream_url "https://wiki.linuxfoundation.org/networking/iproute2"
 :source {:url "https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-4.16.0.tar.xz"
          :sha256 :0c5c24020fd7349fe25728c5edee9fb6a1bc8a38f08e23be5c57a6301e55ee0a}
 :deps [:karate/glibc :karate/iptables]
 :build_deps [:karate/bison
              :karate/flex
              :karate/gcc
              :karate/m4
              :karate/make
              :karate/pkg-config]
 :bin_dirs [:sbin]
 :lib_dirs [:lib]
 :build (fn [b]
          (local v-sbindir (.. b.prefix :/sbin))
          (b:env :SBINDIR v-sbindir)
          (b.default.build b))
 :on {:x86_64-linux-kernel2 {:version :4.10.0
                             :license [:GPL-2.0]
                             :description "Collection of utilities for controlling TCP/IP networking"
                             :upstream_url "https://wiki.linuxfoundation.org/networking/iproute2"
                             :source {:url "https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-4.10.0.tar.xz"
                                      :sha256 :22b1e1c1fc704ad35837e5a66103739727b8b48ac90b48c13f79b7367ff0a9a8}
                             :deps [:karate/glibc]
                             :build_deps [:karate/bison
                                          :karate/flex
                                          :karate/gcc
                                          :karate/iptables
                                          :karate/m4
                                          :karate/make
                                          :karate/pkg-config]
                             :bin_dirs [:sbin]
                             :lib_dirs [:lib]
                             :build (fn [b]
                                      (local v-sbindir (.. b.prefix :/sbin))
                                      (b:env :SBINDIR v-sbindir)
                                      (b.default.build b))}}}
