;; libgcrypt, ported from its plan.sh.
;; libgcrypt 1.12.4, the latest release on 2026-10-26: 1.7.10's source no longer downloads.
{:name :libgcrypt
 :origin :karate
 :version :1.12.4
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:lgplv2+]
 :description "Libgcrypt is a general purpose cryptographic library originally based on code from GnuPG."
 :upstream_url "https://www.gnupg.org/software/libgcrypt/index.html"
 :source {:url "https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.12.4.tar.bz2"
          :sha256 :d77f68f48879510e79a2f65977ccc68981781ea0923e5bdffac2a193ea3d660e}
 :deps [:karate/glibc :karate/libgpg-error]
 :build_deps [:karate/gcc
              :karate/coreutils
              :karate/sed
              :karate/bison
              :karate/flex
              :karate/grep
              :karate/bash
              :karate/gawk
              :karate/libtool
              :karate/diffutils
              :karate/findutils
              :karate/xz
              :karate/gettext
              :karate/gzip
              :karate/make
              :karate/patch
              :karate/texinfo
              :karate/util-linux]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :build (fn [b]
          (b:run [:./configure
                  (.. :--prefix= b.prefix)
                  :--enable-static
                  :--enable-shared])
          (b:run [:make]))
 :check (fn [b]
          (b:run [:make :check]))}
