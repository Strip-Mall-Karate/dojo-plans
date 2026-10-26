;; gecode, ported from its plan.sh.
{:name "gecode"
 :origin "karate"
 :version "3.7.3"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "Gecode is a toolkit for developing constraint-based systems and applications"
 :upstream_url "http://www.gecode.org"
 :source {:url "https://github.com/Gecode/gecode/archive/release-3.7.3.tar.gz" :sha256 "75faaaa025a154ec0aef8b3b6ed9e78113efb543a92b8f4b2b971a0b0e898108" :dirname "gecode-release-3.7.3"}
 :deps ["karate/gcc-libs" "karate/glibc"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/gcc" "karate/make" "karate/perl"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--disable-doc-dot" "--disable-doc-search" "--disable-doc-tagfile" "--disable-doc-chm" "--disable-doc-docset" "--disable-qt" "--disable-examples"])
          (b:run ["make" "-j" (tostring b.jobs)]))
 :check (fn [b]
          (b:run ["make" "check"] {:env {"LD_LIBRARY_PATH" b.src}}))}
