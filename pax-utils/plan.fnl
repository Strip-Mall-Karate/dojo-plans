;; pax-utils, ported from its plan.sh.
{:name "pax-utils"
 :origin "karate"
 :version "1.2.3"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL"]
 :description "ELF related utils for ELF 32/64 binaries that can check files\nfor security relevant properties"
 :upstream_url "http://hardened.gentoo.org/pax-utils.xml"
 :source {:url "http://distfiles.gentoo.org/distfiles/pax-utils-1.2.3.tar.xz" :sha256 "d231b1a34aea2b9205c24fada79a8251d4c3fbcce49367fc055fe43e4c9783b2"}
 :deps ["karate/bash" "karate/glibc" "karate/libcap"]
 :build_deps ["karate/diffutils" "karate/gcc" "karate/make" "karate/pkg-config"]
 :bin_dirs ["bin"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--with-caps" "--without-python"])
          (b:run ["make"]))
 :check (fn [b]
          (b:run ["make" "check" "USE_PYTHON=no"]))
 :install (fn [b]
          (b.default.install b)
          (b:fix_interpreter (b:glob (.. b.prefix "/bin") "*") "karate/bash" "bin/bash"))}
