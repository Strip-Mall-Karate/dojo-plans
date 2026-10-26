;; gmp, ported from its plan.sh.
{:name "gmp"
 :origin "karate"
 :version "6.1.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["gplv3"]
 :description "GMP is a free library for arbitrary precision arithmetic, operating on signed integers, rational numbers, and floating-point numbers."
 :upstream_url "https://gmplib.org"
 :source {:url "http://ftp.gnu.org/gnu/gmp/gmp-6.1.2.tar.xz" :sha256 "87b565e89a9a684fe4ebeeddb8399dce2599f9c9049854ca8c0dfbdea0e21912"}
 :deps ["karate/glibc"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/binutils" "karate/m4"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :prepare (fn [b]
          (b.default.prepare b)
          (b:env "LDFLAGS" (.. (or (b:getenv "LDFLAGS") "") " -Wl,-rpath=" (or (b:getenv "LD_RUN_PATH") "") ",--enable-new-dtags"))
          (b:log (.. "Updating LDFLAGS=" (or (b:getenv "LDFLAGS") ""))))
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--build=x86_64-unknown-linux-gnu"])
          (b:run ["make" (.. "-j" (tostring b.jobs))]))
 :check (fn [b]
          (b:run ["make" "check"]))}
