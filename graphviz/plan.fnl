;; graphviz, ported from its plan.sh.
{:name "graphviz"
 :origin "karate"
 :version "2.40.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["EPL-1.0"]
 :description "Graphviz - Graph Visualization Software"
 :upstream_url "https://graphviz.gitlab.io/"
 :source {:url "https://gitlab.com/graphviz/graphviz/-/archive/stable_release_2.40.1/graphviz-stable_release_2.40.1.tar.bz2" :sha256 "92f654c95b412920777ceddf90e6564ffa871a77e4f6155ab437a2d3a2129e2b" :dirname "graphviz-stable_release_2.40.1"}
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
