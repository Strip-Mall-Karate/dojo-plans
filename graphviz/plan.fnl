;; graphviz, ported from its plan.sh.
;; graphviz 16.1.0, the latest release on 2026-10-26: 2.40.1's source no longer downloads.
{:name "graphviz"
 :origin "karate"
 :version "16.1.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["EPL-1.0"]
 :description "Graphviz - Graph Visualization Software"
 :upstream_url "https://graphviz.gitlab.io/"
 :source {:url "https://gitlab.com/graphviz/graphviz/-/archive/16.1.0/graphviz-16.1.0.tar.bz2" :sha256 "f6ae3cafc0c4778bb1eaf6f1ee7cd0410208089b239099186f87cf04f60cc5d4"}
 :deps ["karate/glibc" "karate/libtool"]
 :build_deps ["karate/autoconf" "karate/automake" "karate/bison" "karate/coreutils" "karate/diffutils" "karate/flex" "karate/gcc" "karate/make" "karate/pkg-config"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :prepare (fn [b]
          (b:copy (.. (b:path_for "karate/pkg-config") "/share/aclocal/pkg.m4") (b:join (.. (b:path_for "karate/automake") "/share/aclocal/") (: (.. (b:path_for "karate/pkg-config") "/share/aclocal/pkg.m4") :match "[^/]+$")))
          (b:run ["libtoolize"])
          (b:run ["./autogen.sh"]))
 :install (fn [b]
          (b:run ["make" "install"])
          (b:copy (b:join b.src "COPYING") (.. b.prefix "/share/licenses/license.txt"))
          (b:chmod (.. b.prefix "/share/licenses/license.txt") "644"))}
