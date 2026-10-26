;; dpkg, ported from its plan.sh.
;; dpkg 1.23.11, the latest release on 2026-10-26: 1.19.4's source no longer downloads.
{:name "dpkg"
 :origin "karate"
 :version "1.23.11"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0"]
 :description "dpkg is a package manager for Debian-based systems"
 :upstream_url "https://wiki.debian.org/dpkg"
 :source {:url "https://deb.debian.org/debian/pool/main/d/dpkg/dpkg_1.23.11.tar.xz" :sha256 "4baf0632157bfac430b7dc1fe8800ea0787dac91f8bb272404ae19d98e569dd3" :filename "dpkg_1.23.11.tar.xz"}
 :deps ["karate/bzip2" "karate/glibc" "karate/ncurses" "karate/tar" "karate/zlib" "karate/xz"]
 :build_deps ["karate/autoconf" "karate/automake" "karate/bzip2" "karate/gcc" "karate/gettext" "karate/libtool" "karate/patch" "karate/make" "karate/perl" "karate/pkg-config" "karate/xz" "karate/zlib"]
 :bin_dirs ["bin" "sbin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix)])
          (b:run ["make"]))}
