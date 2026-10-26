;; libgpg-error, ported from its plan.sh.
{:name "libgpg-error"
 :origin "karate"
 :version "1.20"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["lgplv2+"]
 :source {:url "ftp://ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.20.tar.bz2" :sha256 "3266895ce3419a7fb093e63e95e2ee3056c481a9bc0d6df694cfd26f74e72522"}
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
