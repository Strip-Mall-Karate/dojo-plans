;; libassuan, ported from its plan.sh.
{:name "libassuan"
 :origin "karate"
 :version "2.4.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["lgplv2+"]
 :source {:url "ftp://ftp.gnupg.org/gcrypt/libassuan/libassuan-2.4.2.tar.bz2" :sha256 "bb06dc81380b74bf1b64d5849be5c0409a336f3b4c45f20ac688e86d1b5bcb20"}
 :deps ["karate/glibc" "karate/libgpg-error"]
 :build_deps ["karate/gcc" "karate/coreutils" "karate/sed" "karate/bison" "karate/flex" "karate/grep" "karate/bash" "karate/gawk" "karate/libtool" "karate/diffutils" "karate/findutils" "karate/xz" "karate/gettext" "karate/gzip" "karate/make" "karate/patch" "karate/texinfo" "karate/util-linux"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) (.. "--with-libgpg-error-prefix=" (b:path_for "libgpg-error")) "--enable-static" "--enable-shared"])
          (b:run ["make"]))
 :check (fn [b]
          (b:run ["make" "check"]))
 :strip (fn [b]
          nil)}
