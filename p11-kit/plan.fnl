;; p11-kit, ported from its plan.sh.
{:name "p11-kit"
 :origin "karate"
 :version "0.23.10"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["BSD-3-Clause"]
 :description "Provides a way to load and enumerate PKCS#11 modules."
 :upstream_url "https://p11-glue.github.io/p11-glue/p11-kit.html"
 :source {:url "https://github.com/p11-glue/p11-kit/releases/download/0.23.10/p11-kit-0.23.10.tar.gz" :sha256 "f9212a3f225ef543e13fae9945527d66c0cbb67246320035dd94fab2bce5ae43"}
 :deps ["karate/libtasn1" "karate/libffi"]
 :build_deps ["karate/diffutils" "karate/gcc" "karate/make" "karate/pkg-config" "karate/gettext"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--without-trust-paths"])
          (b:run ["make"]))
 :check (fn [b]
          (b:run ["make" "check"]))}
