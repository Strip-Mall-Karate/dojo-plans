;; elfutils, ported from its plan.sh.
;; elfutils 0.197, the latest release on 2026-10-27: 0.175 does not build with gcc 16.
{:name "elfutils"
 :origin "karate"
 :version "0.197"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-3.0"]
 :description "elfutils is a collection of various binary tools such as\neu-objdump, eu-readelf, and other utilities that allow you to inspect and\nmanipulate ELF files."
 :upstream_url "https://sourceware.org/elfutils/"
 :source {:url "https://sourceware.org/elfutils/ftp/0.197/elfutils-0.197.tar.bz2" :sha256 "1fdf525f22dcf796d99a99ba3ea00a1f7b1ae5421bc62e8443a708920b99b904"}
 :deps ["karate/glibc" "karate/zlib" "karate/gcc-libs"]
 :build_deps ["karate/gcc" "karate/glibc" "karate/m4" "karate/make" "karate/zlib"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 ;; debuginfod needs libcurl and libmicrohttpd, and has no use in a package build.
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--disable-debuginfod" "--enable-libdebuginfod=dummy"])
          (b:run ["make" (.. "-j" (tostring b.jobs))]))}
