;; libassuan, ported from its plan.sh.
;; libassuan 3.0.2, the latest release on 2026-10-26: 2.4.2's source no longer downloads.
{:name :libassuan
 :origin :karate
 :version :3.0.2
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:lgplv2+]
 :source {:url "https://www.gnupg.org/ftp/gcrypt/libassuan/libassuan-3.0.2.tar.bz2"
          :sha256 :d2931cdad266e633510f9970e1a2f346055e351bb19f9b78912475b8074c36f6}
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
                  (.. :--with-libgpg-error-prefix= (b:path_for :libgpg-error))
                  :--enable-static
                  :--enable-shared])
          (b:run [:make]))
 :check (fn [b]
          (b:run [:make :check]))
 :strip (fn [_b]
          nil)}
