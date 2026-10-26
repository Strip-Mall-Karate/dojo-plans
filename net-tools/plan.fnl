;; net-tools, ported from its plan.sh.
{:name "net-tools"
 :origin "karate"
 :version "1.60"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0"]
 :source {:url "http://downloads.sourceforge.net/net-tools/net-tools-1.60.tar.bz2" :sha256 "7ae4dd6d44d6715f18e10559ffd270511b6e55a8900ca54fbebafe0ae6cf7d7b" :dirname "net-tools-1.60"}
 :deps ["karate/glibc" "karate/coreutils"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc"]
 :bin_dirs ["bin" "sbin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["patch" "-p1" "-i" (.. b.plan_dir "/fix_default.patch")])
          (if (b:exists (.. b.cache "/net-tools-1.60/config.h"))
            (b:copy (.. b.plan_dir "/config.h") (b:join (.. b.cache "/net-tools-1.60/config.h") (: (.. b.plan_dir "/config.h") :match "[^/]+$")))
            (b:copy (.. b.plan_dir "/config.h") (.. b.cache "/net-tools-1.60/config.h")))
          (b:run ["make"]))
 :install (fn [b]
          (b:run ["make" "install" (.. "BASEDIR=" b.prefix)]))}
