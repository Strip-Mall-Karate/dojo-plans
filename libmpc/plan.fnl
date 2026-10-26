;; libmpc, ported from its plan.sh.
{:name "libmpc"
 :origin "karate"
 :version "1.1.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["lgpl"]
 :description "GNU MPC is a C library for the arithmetic of complex numbers with arbitrarily high precision and correct rounding of the result."
 :upstream_url "http://www.multiprecision.org/"
 :source {:url "https://ftp.gnu.org/gnu/mpc/mpc-1.1.0.tar.gz" :sha256 "6985c538143c1208dcb1ac42cedad6ff52e267b47e5f970183a3e75125b43c2e" :dirname "mpc-1.1.0"}
 :deps ["karate/glibc" "karate/gmp" "karate/mpfr"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/binutils"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :prepare (fn [b]
          (b.default.prepare b)
          (b:env "LDFLAGS" (.. (or (b:getenv "LDFLAGS") "") " -Wl,-rpath=" (or (b:getenv "LD_RUN_PATH") "") ",--enable-new-dtags"))
          (b:log (.. "Updating LDFLAGS=" (or (b:getenv "LDFLAGS") ""))))
 :check (fn [b]
          (b:run ["make" "check"]))}
