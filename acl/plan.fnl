;; acl, ported from its plan.sh.
{:name "acl"
 :origin "karate"
 :version "2.2.53"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["lgpl"]
 :description "Commands for Manipulating POSIX Access Control Lists."
 :upstream_url "https://savannah.nongnu.org/projects/acl"
 :source {:url "http://download.savannah.gnu.org/releases/acl/acl-2.2.53.tar.gz" :sha256 "06be9865c6f418d851ff4494e12406568353b891ffe1f596b34693c387af26c7"}
 :deps ["karate/glibc" "karate/attr"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/file" "karate/gcc" "karate/gettext"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :install (fn [b]
          (b:run ["make" "install"]))}
