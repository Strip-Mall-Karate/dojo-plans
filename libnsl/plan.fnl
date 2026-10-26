;; libnsl, ported from its plan.sh.
{:name "libnsl"
 :origin "karate"
 :version "1.2.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["LGPL-2.1-or-later"]
 :description "This library contains the public client interface for NIS(YP) and NIS+ in a IPv6 ready version"
 :upstream_url "https://github.com/thkukuk/libnsl"
 :source {:url "https://github.com/thkukuk/libnsl/archive/v1.2.0.tar.gz" :sha256 "a5a28ef17c4ca23a005a729257c959620b09f8c7f99d0edbfe2eb6b06bafd3f8"}
 :deps ["karate/glibc"]
 :build_deps ["karate/autoconf" "karate/automake" "karate/diffutils" "karate/gcc" "karate/gettext" "karate/libtool" "karate/make" "karate/pkg-config"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :prepare (fn [b]
          (var v-aclocal-path (.. (or (b:getenv "ACLOCAL_PATH") "") ":" (b:path_for "karate/gettext") "/share/aclocal:" (b:path_for "karate/pkg-config") "/share/aclocal"))
          (b:env "ACLOCAL_PATH" v-aclocal-path)
          (b:run ["./autogen.sh"]))}
