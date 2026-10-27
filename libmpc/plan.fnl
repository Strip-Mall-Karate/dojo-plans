;; libmpc, ported from its plan.sh.
;; libmpc 1.4.1, the latest release on 2026-10-26.
{:name :libmpc
 :origin :karate
 :version :1.4.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:lgpl]
 :description "GNU MPC is a C library for the arithmetic of complex numbers with arbitrarily high precision and correct rounding of the result."
 :upstream_url "http://www.multiprecision.org/"
 :source {:url "https://ftp.gnu.org/gnu/mpc/mpc-1.4.1.tar.xz"
          :sha256 :91204cd32f164bd3b7c992d4a6a8ce6519511aadab30f78b6982d0bf8d73e931
          :dirname :mpc-1.4.1}
 :deps [:karate/glibc :karate/gmp :karate/mpfr]
 :build_deps [:karate/coreutils
              :karate/diffutils
              :karate/patch
              :karate/make
              :karate/gcc
              :karate/binutils]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :prepare (fn [b]
            (b.default.prepare b)
            (b:env :LDFLAGS
                   (.. (or (b:getenv :LDFLAGS) "") " -Wl,-rpath="
                       (or (b:getenv :LD_RUN_PATH) "") ",--enable-new-dtags"))
            (b:log (.. "Updating LDFLAGS=" (or (b:getenv :LDFLAGS) ""))))
 :check (fn [b]
          (b:run [:make :check]))}
