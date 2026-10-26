;; gsl, ported from its plan.sh.
{:name "gsl"
 :origin "karate"
 :version "2.3"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPLv3"]
 :description "GSL is a numerical library for C and C++"
 :upstream_url "https://www.gnu.org/software/gsl/"
 :source {:url "http://ftp.gnu.org/gnu/gsl/gsl-2.3.tar.gz" :sha256 "562500b789cd599b3a4f88547a7a3280538ab2ff4939504c8b4ac4ca25feadfb"}
 :deps ["karate/glibc"]
 :build_deps ["karate/make" "karate/gcc" "karate/diffutils"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :prepare (fn [b]
          (b:env "CFLAGS" (.. (or (b:getenv "CFLAGS") "") " -O2")))
 :check (fn [b]
          (b:run ["make" "check"]))}
