;; npth, ported from its plan.sh.
;; npth 1.8, the latest release on 2026-10-26: 1.2's source no longer downloads.
{:name "npth"
 :origin "karate"
 :version "1.8"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["lgplv3+"]
 :source {:url "https://www.gnupg.org/ftp/gcrypt/npth/npth-1.8.tar.bz2" :sha256 "8bd24b4f23a3065d6e5b26e98aba9ce783ea4fd781069c1b35d149694e90ca3e"}
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
