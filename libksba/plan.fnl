;; libksba, ported from its plan.sh.
{:name "libksba"
 :origin "karate"
 :version "1.3.3"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["lgplv3+"]
 :source {:url "ftp://ftp.gnupg.org/gcrypt/libksba/libksba-1.3.3.tar.bz2" :sha256 "0c7f5ffe34d0414f6951d9880a46fcc2985c487f7c36369b9f11ad41131c7786"}
 :deps ["karate/glibc" "karate/libgpg-error"]
 :build_deps ["karate/gcc" "karate/coreutils" "karate/sed" "karate/bison" "karate/flex" "karate/grep" "karate/bash" "karate/gawk" "karate/libtool" "karate/diffutils" "karate/findutils" "karate/xz" "karate/gettext" "karate/gzip" "karate/make" "karate/patch" "karate/texinfo" "karate/util-linux"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--enable-static" "--enable-shared"])
          (b:run ["make"]))
 :check (fn [b]
          (b:run ["make" "check"]))}
