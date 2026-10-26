;; elfutils, ported from its plan.sh.
{:name "elfutils"
 :origin "karate"
 :version "0.175"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-3.0"]
 :description "elfutils is a collection of various binary tools such as\neu-objdump, eu-readelf, and other utilities that allow you to inspect and\nmanipulate ELF files."
 :upstream_url "https://sourceware.org/elfutils/"
 :source {:url "https://sourceware.org/elfutils/ftp/0.175/elfutils-0.175.tar.bz2" :sha256 "f7ef925541ee32c6d15ae5cb27da5f119e01a5ccdbe9fe57bf836730d7b7a65b"}
 :deps ["karate/glibc" "karate/zlib" "karate/gcc-libs"]
 :build_deps ["karate/gcc" "karate/glibc" "karate/m4" "karate/make" "karate/zlib"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]}
