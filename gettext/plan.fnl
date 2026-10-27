;; gettext, ported from its plan.sh.
;; gettext 1.0, the latest release on 2026-10-26.
{:name "gettext"
 :origin "karate"
 :version "1.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["gplv2+" "lgpl2+"]
 :description "GNU internationalization library."
 :upstream_url "http://www.gnu.org/software/gettext/"
 :source {:url "https://ftp.gnu.org/gnu/gettext/gettext-1.0.tar.xz" :sha256 "71132a3fb71e68245b8f2ac4e9e97137d3e5c02f415636eb508ae607bc01add7"}
 :deps ["karate/glibc" "karate/gcc-libs" "karate/acl" "karate/xz"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/sed" "karate/findutils"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :prepare (fn [b]
          (b.default.prepare b)
          ;; Plans that build with it find its m4 macros: aclocal reads ACLOCAL_PATH.
          (b:buildtime_env_push "ACLOCAL_PATH" (.. b.prefix "/share/aclocal"))
          (b:run ["patch" "-p1" "-i" (.. b.plan_dir "/disable-test.patch")]))
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix)])
          (b:run ["make" (.. "-j" (tostring b.jobs))]))
 :check (fn [b]
          (b:run ["make" "check"]))}
