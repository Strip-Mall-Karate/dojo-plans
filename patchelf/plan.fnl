;; patchelf, ported from its plan.sh.
;; patchelf 0.19.2, the latest release on 2026-10-26.
;; The plan's FIRST_PASS build, linked against gcc before gcc-libs existed, was the
;; source project's bootstrap; Dojo bootstraps from nixpkgs, so this is the plan's
;; normal build.
{:name "patchelf"
 :origin "karate"
 :version "0.19.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["gplv3"]
 :description "A small utility to modify the dynamic linker and RPATH of ELF executables."
 :upstream_url "https://nixos.org/patchelf.html"
 :source {:url "https://github.com/NixOS/patchelf/releases/download/0.19.2/patchelf-0.19.2.tar.gz" :sha256 "78cb26bda2b89fababfe189c2f6507240340f1aa45dec2eb49a39473a50ceea1"}
 :deps ["karate/glibc" "karate/gcc-libs"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc"]
 :bin_dirs ["bin"]}
