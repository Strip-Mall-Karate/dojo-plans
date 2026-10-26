;; libtermkey, ported from its plan.sh.
{:name "libtermkey"
 :origin "karate"
 :version "0.20"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "This library allows easy processing of keyboard entry from terminal-based programs."
 :upstream_url "http://www.leonerd.org.uk/code/libtermkey/"
 :source {:url "http://www.leonerd.org.uk/code/libtermkey/libtermkey-0.20.tar.gz" :sha256 "6c0d87c94ab9915e76ecd313baec08dedf3bd56de83743d9aa923a081935d2f5"}
 :deps ["karate/glibc" "karate/ncurses"]
 :build_deps ["karate/gcc" "karate/libtool" "karate/make" "karate/pkg-config"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["make" (.. "PREFIX=" b.prefix)]))
 :install (fn [b]
          (b:run ["make" "install" (.. "PREFIX=" b.prefix)]))}
