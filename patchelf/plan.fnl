;; patchelf, ported from its plan.sh.
;; The plan's FIRST_PASS build, linked against gcc before gcc-libs existed, was the
;; source project's bootstrap; Dojo bootstraps from nixpkgs, so this is the plan's
;; normal build.
{:name "patchelf"
 :origin "karate"
 :version "0.9"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["gplv3"]
 :description "A small utility to modify the dynamic linker and RPATH of ELF executables."
 :upstream_url "https://nixos.org/patchelf.html"
 :source {:url "http://nixos.org/releases/patchelf/patchelf-0.9/patchelf-0.9.tar.gz" :sha256 "f2aa40a6148cb3b0ca807a1bf836b081793e55ec9e5540a5356d800132be7e0a"}
 :deps ["karate/glibc" "karate/gcc-libs"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc"]
 :bin_dirs ["bin"]}
