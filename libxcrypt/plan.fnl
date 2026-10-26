;; libxcrypt 4.5.2, the latest release on 2026-10-26. Written for Dojo: glibc 2.39 and later no
;; longer provide libcrypt, which shadow and perl's crypt use.
{:name "libxcrypt"
 :origin "karate"
 :version "4.5.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["LGPL-2.1-or-later"]
 :description "An extended crypt library for password hashing, with the crypt functions glibc's libcrypt had."
 :upstream_url "https://github.com/besser82/libxcrypt"
 :source {:url "https://github.com/besser82/libxcrypt/releases/download/v4.5.2/libxcrypt-4.5.2.tar.xz" :sha256 "71513a31c01a428bccd5367a32fd95f115d6dac50fb5b60c779d5c7942aec071"}
 :deps ["karate/glibc"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/make" "karate/gcc" "karate/perl"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :build (fn [b]
          ;; Its warnings are errors by default, and glibc 2.43 and later's C23 strchr returns a
          ;; const pointer for a const argument, which it assigns to a plain one.
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--disable-werror"])
          (b:run ["make" (.. "-j" (tostring b.jobs))]))
 :check (fn [b]
          (b:run ["make" "check"]))}
