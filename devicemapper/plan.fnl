;; devicemapper, ported from its plan.sh.
{:name :devicemapper
 :origin :karate
 :version :2.03.00
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0]
 :description "The Device-mapper is a component of the linux kernel (since version 2.6) that supports logical volume management."
 :upstream_url "https://sourceware.org/lvm2/"
 :source {:url "https://mirrors.kernel.org/sourceware/lvm2/releases/LVM2.2.03.00.tgz"
          :sha256 :405992bf76960e60c7219d84d5f1e22edc34422a1ea812e21b2ac3c813d0da4e
          :dirname :LVM2.2.03.00}
 :deps [:karate/glibc :karate/libaio]
 :build_deps [:karate/gcc :karate/make]
 :bin_dirs [:sbin]
 :lib_dirs [:lib]
 :include_dirs [:include]}
