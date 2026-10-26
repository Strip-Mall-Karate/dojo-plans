;; libxt, ported from its plan.sh.
{:name "libxt"
 :origin "karate"
 :version "1.1.5"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "X11 toolkit intrinsics library"
 :upstream_url "https://www.x.org/"
 :source {:url "https://www.x.org/releases/individual/lib/libXt-1.1.5.tar.bz2" :sha256 "46eeb6be780211fdd98c5109286618f6707712235fdd19df4ce1e6954f349f1a" :dirname "libXt-1.1.5"}
 :deps ["karate/glibc" "karate/xlib" "karate/libxcb" "karate/libxau" "karate/libxdmcp" "karate/libsm" "karate/libice"]
 :build_deps ["karate/gcc" "karate/make" "karate/pkg-config" "karate/xproto" "karate/kbproto" "karate/libpthread-stubs"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :check (fn [b]
          (b:run ["make" "check"]))}
