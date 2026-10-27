;; libksba, ported from its plan.sh.
;; libksba 1.8.1, the latest release on 2026-10-26: 1.3.3's source no longer downloads.
{:name :libksba
 :origin :karate
 :version :1.8.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:lgplv3+]
 :source {:url "https://www.gnupg.org/ftp/gcrypt/libksba/libksba-1.8.1.tar.bz2"
          :sha256 :c2f84393011827219ae117131dba8e7684c2bed0961eed11b0642c2acba440b5}
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
