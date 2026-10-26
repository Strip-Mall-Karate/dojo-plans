;; acl, ported from its plan.sh.
;; acl 2.4.0, the latest release on 2026-10-26.
{:name "acl"
 :origin "karate"
 :version "2.4.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["lgpl"]
 :description "Commands for Manipulating POSIX Access Control Lists."
 :upstream_url "https://savannah.nongnu.org/projects/acl"
 :source {:url "https://download.savannah.nongnu.org/releases/acl/acl-2.4.0.tar.xz" :sha256 "e661131456d2708a01c614a0f400e11d7d1bfaeb6f3e74b75bb980b72f0161a3"}
 :deps ["karate/glibc" "karate/attr"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/file" "karate/gcc" "karate/gettext"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :install (fn [b]
          (b:run ["make" "install"]))}
