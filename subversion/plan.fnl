;; subversion, ported from its plan.sh.
{:name "subversion"
 :origin "karate"
 :version "1.9.4"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "Enterprise-class centralized version control for the masses"
 :upstream_url "https://subversion.apache.org/"
 :source {:url "https://archive.apache.org/dist/subversion/subversion-1.9.4.tar.bz2" :sha256 "1267f9e2ab983f260623bee841e6c9cc458bf4bf776238ed5f100983f79e9299"}
 :deps ["karate/gcc-libs" "karate/serf" "karate/zlib"]
 :build_deps ["karate/apr" "karate/apr-util" "karate/coreutils" "karate/diffutils" "karate/gcc" "karate/make" "karate/pkg-config" "karate/python2" "karate/sqlite"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) (.. "--with-serf=" (b:path_for "serf"))])
          (b:run ["make"]))
 :check (fn [b]
          (b:run ["make" "check"]))}
