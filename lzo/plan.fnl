;; lzo, ported from its plan.sh.
{:name "lzo"
 :origin "karate"
 :version "2.09"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL"]
 :source {:url "http://www.oberhumer.com/opensource/lzo/download/lzo-2.09.tar.gz" :sha256 "f294a7ced313063c057c504257f437c8335c41bfeed23531ee4e6a2b87bcb34c" :filename "lzo-2.09.tar.gz"}
 :deps ["karate/glibc"]
 :build_deps ["karate/coreutils" "karate/make" "karate/gcc"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--enable-shared" "--disable-static"])
          (b:run ["make"]))}
