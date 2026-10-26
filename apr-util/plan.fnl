;; apr-util, ported from its plan.sh.
{:name "apr-util"
 :origin "karate"
 :version "1.6.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "Apache Portable Runtime util"
 :upstream_url "https://apr.apache.org/"
 :source {:url "https://archive.apache.org/dist/apr/apr-util-1.6.1.tar.bz2" :sha256 "d3e12f7b6ad12687572a3a39475545a072608f4ba03a6ce8a3778f607dd0035b"}
 :deps ["karate/gcc-libs" "karate/glibc" "karate/apr" "karate/expat"]
 :build_deps ["karate/gcc" "karate/make"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) (.. "--with-apr=" (b:path_for "karate/apr")) (.. "--with-expat=" (b:path_for "karate/expat"))])
          (b:run ["make"]))}
