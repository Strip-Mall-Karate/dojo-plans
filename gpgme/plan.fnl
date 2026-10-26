;; gpgme, ported from its plan.sh.
{:name "gpgme"
 :origin "karate"
 :version "1.6.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["LGPL"]
 :source {:url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.6.0.tar.bz2" :sha256 "b09de4197ac280b102080e09eaec6211d081efff1963bf7821cf8f4f9916099d"}
 :deps ["karate/glibc" "karate/libassuan" "karate/libgpg-error"]
 :build_deps ["karate/gcc" "karate/coreutils" "karate/make"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) (.. "--with-libgpg-error-prefix=" (b:path_for "libgpg-error")) (.. "--with-libassuan-prefix=" (b:path_for "libassuan"))])
          (b:run ["make"]))}
