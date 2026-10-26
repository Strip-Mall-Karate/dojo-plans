;; libgcrypt, ported from its plan.sh.
{:name "libgcrypt"
 :origin "karate"
 :version "1.7.10"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["lgplv2+"]
 :description "Libgcrypt is a general purpose cryptographic library originally based on code from GnuPG."
 :upstream_url "https://www.gnupg.org/software/libgcrypt/index.html"
 :source {:url "ftp://ftp.gnupg.org/gcrypt/libgcrypt/libgcrypt-1.7.10.tar.bz2" :sha256 "89f05a423dd66a25e5b38308097e2386e640d1cf835160d19a5c75350071d94c"}
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
