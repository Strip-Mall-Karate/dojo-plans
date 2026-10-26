;; gettext, ported from its plan.sh.
{:name "gettext"
 :origin "karate"
 :version "0.19.8"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["gplv2+" "lgpl2+"]
 :description "GNU internationalization library."
 :upstream_url "http://www.gnu.org/software/gettext/"
 :source {:url "http://ftp.gnu.org/gnu/gettext/gettext-0.19.8.tar.gz" :sha256 "3da4f6bd79685648ecf46dab51d66fcdddc156f41ed07e580a696a38ac61d48f"}
 :deps ["karate/glibc" "karate/gcc-libs" "karate/acl" "karate/xz"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/sed" "karate/findutils"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :prepare (fn [b]
          (b.default.prepare b)
          (b:run ["patch" "-p1" "-i" (.. b.plan_dir "/disable-test.patch")]))
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix)])
          (b:run ["make" (.. "-j" (tostring b.jobs))]))
 :check (fn [b]
          (b:run ["make" "check"]))}
