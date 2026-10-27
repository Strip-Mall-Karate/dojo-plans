;; attr, ported from its plan.sh.
;; attr 2.6.0, the latest release on 2026-10-26.
{:name :attr
 :origin :karate
 :version :2.6.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-2.0]
 :description "Commands for Manipulating Filesystem Extended Attributes"
 :upstream_url "https://savannah.nongnu.org/projects/attr/"
 :source {:url "https://download.savannah.nongnu.org/releases/attr/attr-2.6.0.tar.xz"
          :sha256 :6c8a2148a7b85043b68492bce43316b0e2e214fc4e628c7ede078e76e216330b}
 :deps [:karate/glibc]
 :build_deps [:karate/coreutils
              :karate/diffutils
              :karate/make
              :karate/gcc
              :karate/gettext]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :install (fn [b]
            (b:run [:make :install]))}
