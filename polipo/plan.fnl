;; polipo, ported from its plan.sh.
{:name "polipo"
 :origin "karate"
 :version "1.1.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["mit"]
 :source {:url "https://github.com/jech/polipo/archive/polipo-1.1.1.tar.gz" :sha256 "de0afeeaa47df776420e59b69e9a78f68e8a7bc4a46b739772e1d91119ed2405" :dirname "polipo-polipo-1.1.1"}
 :deps ["karate/glibc"]
 :build_deps ["karate/gcc" "karate/make"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :exports {"port" "port"}
 :exposes ["port"]
 :build (fn [b]
          (b:run ["make"]))
 :install (fn [b]
          (b:copy (b:join b.src "polipo") (b:join (.. b.prefix "/bin/") (: (b:join b.src "polipo") :match "[^/]+$"))))}
