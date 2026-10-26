;; mpfr, ported from its plan.sh.
;; mpfr 4.2.2, the latest release on 2026-10-26.
{:name "mpfr"
 :origin "karate"
 :version "4.2.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["lgpl"]
 :description "GNU MPFR (GNU Multiple Precision Floating-Point Reliably) is a GNU portable C library for arbitrary-precision binary floating-point computation with correct rounding, based on GNU Multi-Precision Library."
 :upstream_url "http://www.mpfr.org/"
 :source {:url "https://ftp.gnu.org/gnu/mpfr/mpfr-4.2.2.tar.xz" :sha256 "b67ba0383ef7e8a8563734e2e889ef5ec3c3b898a01d00fa0a6869ad81c6ce01"}
 :deps ["karate/glibc" "karate/gmp"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/binutils"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :prepare (fn [b]
          (b.default.prepare b)
          (b:env "LDFLAGS" (.. (or (b:getenv "LDFLAGS") "") " -Wl,-rpath=" (or (b:getenv "LD_RUN_PATH") "") ",--enable-new-dtags"))
          (b:log (.. "Updating LDFLAGS=" (or (b:getenv "LDFLAGS") ""))))
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) (.. "--with-gmp=" (b:path_for "gmp")) "--enable-thread-safe"])
          (b:run ["make" (.. "-j" (tostring b.jobs))]))
 :check (fn [b]
          (b:run ["make" "check"]))}
