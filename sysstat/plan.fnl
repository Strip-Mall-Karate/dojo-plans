;; sysstat, ported from its plan.sh.
{:name "sysstat"
 :origin "karate"
 :version "11.5.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0"]
 :description "Sysstat and the utilities it provides: iostat, mpstat, pidstat, sar, sa1, sa2 and sadf"
 :upstream_url "http://sebastien.godard.pagesperso-orange.fr/"
 :source {:url "http://pagesperso-orange.fr/sebastien.godard/sysstat-11.5.1.tar.gz" :sha256 "285f5a2fc63a40655940bf56a5a28f0ff271d817cd0cdc5e5b56af30efb9c426"}
 :deps ["karate/glibc"]
 :build_deps ["karate/make" "karate/gcc"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]}
