;; libxext, ported from its plan.sh.
{:name "libxext"
 :origin "karate"
 :version "1.3.3"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "X11 miscellaneous extensions library"
 :upstream_url "https://www.x.org/"
 :source {:url "https://www.x.org/releases/individual/lib/libXext-1.3.3.tar.bz2" :sha256 "b518d4d332231f313371fdefac59e3776f4f0823bcb23cf7c7305bfb57b16e35" :dirname "libXext-1.3.3"}
 :deps ["karate/glibc" "karate/xlib" "karate/libxcb" "karate/libxau" "karate/libxdmcp"]
 :build_deps ["karate/gcc" "karate/make" "karate/pkg-config" "karate/xproto" "karate/xextproto" "karate/kbproto" "karate/libpthread-stubs"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :check (fn [b]
          (b:run ["make" "check"]))}
