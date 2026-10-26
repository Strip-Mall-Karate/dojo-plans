;; patchelf, ported from its plan.sh.
;; patchelf 0.19.2, the latest release on 2026-10-26.
;; The source project built patchelf twice, first against gcc before gcc-libs existed and
;; again after it, because gcc-libs' own build runs patchelf. Linking its C++ runtime
;; statically breaks that cycle once: patchelf needs nothing from gcc-libs.
{:name "patchelf"
 :origin "karate"
 :version "0.19.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["gplv3"]
 :description "A small utility to modify the dynamic linker and RPATH of ELF executables."
 :upstream_url "https://nixos.org/patchelf.html"
 :source {:url "https://github.com/NixOS/patchelf/releases/download/0.19.2/patchelf-0.19.2.tar.gz" :sha256 "78cb26bda2b89fababfe189c2f6507240340f1aa45dec2eb49a39473a50ceea1"}
 :deps ["karate/glibc"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc"]
 :bin_dirs ["bin"]
 :prepare (fn [b]
          (b.default.prepare b)
          (b:env "LDFLAGS" (.. (or (b:getenv "LDFLAGS") "") " -static-libstdc++ -static-libgcc")))}
