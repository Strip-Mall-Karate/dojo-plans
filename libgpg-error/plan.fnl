;; libgpg-error, ported from its plan.sh.
;; libgpg-error 1.61, the latest release on 2026-10-26: 1.20's source no longer downloads.
{:name "libgpg-error"
 :origin "karate"
 :version "1.61"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["lgplv2+"]
 :source {:url "https://www.gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.61.tar.bz2" :sha256 "7a85413f2bc354f4f8aa832b718af122e48965e9e0eb9012ee659c13c6385c93"}
 :deps ["karate/glibc"]
 :build_deps ["karate/gcc" "karate/coreutils" "karate/sed" "karate/bison" "karate/flex" "karate/grep" "karate/bash" "karate/gawk" "karate/libtool" "karate/diffutils" "karate/findutils" "karate/xz" "karate/gettext" "karate/gzip" "karate/make" "karate/patch" "karate/texinfo" "karate/util-linux"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--enable-static" "--enable-shared"])
          (b:run ["make"]))
 :check (fn [b]
          (b:run ["make" "check"]))}
