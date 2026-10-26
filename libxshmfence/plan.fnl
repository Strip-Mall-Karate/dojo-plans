;; libxshmfence, ported from its plan.sh.
{:name "libxshmfence"
 :origin "karate"
 :version "1.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "X11 C Bindings"
 :upstream_url "https://www.x.org/"
 :source {:url "https://www.x.org/archive/individual/lib/libxshmfence-1.2.tar.bz2" :sha256 "d21b2d1fd78c1efbe1f2c16dae1cb23f8fd231dcf891465b8debe636a9054b0c"}
 :deps ["karate/glibc"]
 :build_deps ["karate/diffutils" "karate/gcc" "karate/make" "karate/pkg-config" "karate/xproto" "karate/util-macros"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :prepare (fn [b]
          (b:env "CFLAGS" (.. (or (b:getenv "CFLAGS") "") " -Wno-error=implicit-function-declaration")))
 :check (fn [b]
          (b:run ["make" "check"]))}
