;; linux-pam, ported from its plan.sh.
;; linux-pam 1.7.3, the latest release on 2026-10-27: 1.3.0's source no longer downloads.
{:name "linux-pam"
 :origin "karate"
 :version "1.7.3"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["BSD-3-Clause" "GPL"]
 :description "Linux-PAM is a free implementation of the following DCE-RFC from Sunsoft."
 :upstream_url "https://github.com/linux-pam/linux-pam"
 :source {:url "https://github.com/linux-pam/linux-pam/releases/download/v1.7.3/Linux-PAM-1.7.3.tar.xz" :sha256 "2ce4765fd49df6693771ef2941f81e33d8ee14b94a81a5c7b369aa3b137b85a5" :dirname "Linux-PAM-1.7.3"}
 :deps ["karate/glibc" "karate/libxcrypt"]
 :build_deps ["karate/coreutils" "karate/gcc" "karate/meson" "karate/ninja" "karate/pkg-config"]
 :bin_dirs ["sbin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["meson" "setup" "_build" (.. "--prefix=" b.prefix) "--libdir=lib" "--buildtype=release" "-Ddocs=disabled"
                  ;; Its default vendor directory is /usr/share/pam.
                  (.. "-Dvendordir=" b.prefix "/share/pam")])
          (b:run ["ninja" "-C" "_build"]))
 :install (fn [b]
          (b:run ["ninja" "-C" "_build" "install"]))}
