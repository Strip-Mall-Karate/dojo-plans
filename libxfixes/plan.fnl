;; libxfixes, ported from its plan.sh.
{:name "libxfixes"
 :origin "karate"
 :version "5.0.3"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "X.Org Libraries: libXfixes"
 :upstream_url "https://www.x.org/"
 :source {:url "https://www.x.org/releases/individual/lib/libXfixes-5.0.3.tar.bz2" :sha256 "de1cd33aff226e08cefd0e6759341c2c8e8c9faf8ce9ac6ec38d43e287b22ad6" :dirname "libXfixes-5.0.3"}
 :deps ["karate/glibc" "karate/xlib" "karate/libxcb" "karate/libxau" "karate/libxdmcp"]
 :build_deps ["karate/gcc" "karate/make" "karate/pkg-config" "karate/xproto" "karate/kbproto" "karate/xextproto" "karate/fixesproto" "karate/libpthread-stubs"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :check (fn [b]
          (b:run ["make" "check"]))}
