;; libxcb, ported from its plan.sh.
{:name "libxcb"
 :origin "karate"
 :version "1.12"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "X11 C Bindings"
 :upstream_url "https://www.x.org/"
 :source {:url "https://www.x.org/releases/individual/xcb/libxcb-1.12.tar.bz2" :sha256 "4adfb1b7c67e99bc9c2ccb110b2f175686576d2f792c8a71b9c8b19014057b5b"}
 :deps ["karate/glibc" "karate/libxau" "karate/libxdmcp"]
 :build_deps ["karate/diffutils" "karate/gcc" "karate/libpthread-stubs" "karate/make" "karate/pkg-config" "karate/python2" "karate/util-macros" "karate/xproto" "karate/xcb-proto"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :check (fn [b]
          (b:run ["make" "check"]))}
