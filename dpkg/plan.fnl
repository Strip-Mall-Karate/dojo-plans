;; dpkg, ported from its plan.sh.
{:name "dpkg"
 :origin "karate"
 :version "1.19.4"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0"]
 :description "dpkg is a package manager for Debian-based systems"
 :upstream_url "https://wiki.debian.org/dpkg"
 :source {:url "http://http.debian.net/debian/pool/main/d/dpkg/dpkg_1.19.4.tar.xz" :sha256 "c15234e98655689586bff2d517a6fdc6135d139c54d52ae9cfa6a90007fee0ae"}
 :deps ["karate/bzip2" "karate/glibc" "karate/ncurses" "karate/tar" "karate/zlib" "karate/xz"]
 :build_deps ["karate/autoconf" "karate/automake" "karate/bzip2" "karate/gcc" "karate/gettext" "karate/libtool" "karate/patch" "karate/make" "karate/perl" "karate/pkg-config" "karate/xz" "karate/zlib"]
 :bin_dirs ["bin" "sbin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix)])
          (b:run ["make"]))}
