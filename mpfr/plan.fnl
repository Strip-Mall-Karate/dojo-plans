;; mpfr, ported from its plan.sh.
{:name "mpfr"
 :origin "karate"
 :version "4.0.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["lgpl"]
 :description "GNU MPFR (GNU Multiple Precision Floating-Point Reliably) is a GNU portable C library for arbitrary-precision binary floating-point computation with correct rounding, based on GNU Multi-Precision Library."
 :upstream_url "http://www.mpfr.org/"
 :source {:url "http://www.mpfr.org/mpfr-4.0.1/mpfr-4.0.1.tar.xz" :sha256 "67874a60826303ee2fb6affc6dc0ddd3e749e9bfcb4c8655e3953d0458a6e16e"}
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
