;; xtrans, ported from its plan.sh.
{:name "xtrans"
 :origin "karate"
 :version "1.3.5"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "X11 transport library"
 :upstream_url "https://www.x.org/"
 :source {:url "https://www.x.org/releases/individual/lib/xtrans-1.3.5.tar.bz2" :sha256 "adbd3b36932ce4c062cd10f57d78a156ba98d618bdb6f50664da327502bc8301"}
 :deps ["karate/glibc"]
 :build_deps ["karate/gcc" "karate/make" "karate/pkg-config" "karate/util-macros"]
 :include_dirs ["include"]
 :pconfig_dirs ["share/pkgconfig"]
 :check (fn [b]
          (b:run ["make" "check"]))}
