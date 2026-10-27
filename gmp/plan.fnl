;; gmp, ported from its plan.sh.
;; gmp 6.3.0, the latest release on 2026-10-26.
{:name :gmp
 :origin :karate
 :version :6.3.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:gplv3]
 :description "GMP is a free library for arbitrary precision arithmetic, operating on signed integers, rational numbers, and floating-point numbers."
 :upstream_url "https://gmplib.org"
 :source {:url "https://ftp.gnu.org/gnu/gmp/gmp-6.3.0.tar.xz"
          :sha256 :a3c2b80201b89e68616f4ad30bc66aee4927c3ce50e33929ca819d5c43538898}
 :deps [:karate/glibc]
 :build_deps [:karate/coreutils
              :karate/diffutils
              :karate/patch
              :karate/make
              :karate/gcc
              :karate/binutils
              :karate/m4]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :prepare (fn [b]
            (b.default.prepare b)
            (b:env :LDFLAGS
                   (.. (or (b:getenv :LDFLAGS) "") " -Wl,-rpath="
                       (or (b:getenv :LD_RUN_PATH) "") ",--enable-new-dtags"))
            (b:log (.. "Updating LDFLAGS=" (or (b:getenv :LDFLAGS) "")))
            ;; gmp 6.3.0's configure declares functions with () and calls them with arguments,
            ;; which C23, gcc 15's default, rejects.
            (b:env :CFLAGS (.. (or (b:getenv :CFLAGS) "") " -std=gnu17")))
 :build (fn [b]
          (b:run [:./configure
                  (.. :--prefix= b.prefix)
                  :--build=x86_64-unknown-linux-gnu])
          (b:run [:make (.. :-j (tostring b.jobs))]))
 :check (fn [b]
          (b:run [:make :check]))}
