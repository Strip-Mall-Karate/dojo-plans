;; libunistring, ported from its plan.sh.
{:name "libunistring"
 :origin "karate"
 :version "0.9.6"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["LGPL-3.0"]
 :description "Library functions for manipulating Unicode strings"
 :upstream_url "https://www.gnu.org/software/libunistring/"
 :source {:url "https://ftp.gnu.org/gnu/libunistring/libunistring-0.9.6.tar.xz" :sha256 "2df42eae46743e3f91201bf5c100041540a7704e8b9abfd57c972b2d544de41b"}
 :deps ["karate/glibc"]
 :build_deps ["karate/gcc" "karate/make" "karate/diffutils"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :check (fn [b]
          (b:run ["make" "check"]))}
