;; libedit, ported from its plan.sh.
{:name "libedit"
 :origin "karate"
 :version "3.1.20150325"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["bsd"]
 :source {:url "http://thrysoee.dk/editline/libedit-20150325-3.1.tar.gz" :sha256 "c88a5e4af83c5f40dda8455886ac98923a9c33125699742603a88a0253fcc8c5" :dirname "libedit-20150325-3.1"}
 :deps ["karate/glibc" "karate/ncurses"]
 :build_deps ["karate/gcc" "karate/make" "karate/coreutils"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["./configure" "--enable-widec" (.. "--prefix=" b.prefix)]))}
