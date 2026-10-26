;; unibilium, ported from its plan.sh.
{:name "unibilium"
 :origin "karate"
 :version "1.2.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["LGPL-3.0"]
 :description "A terminfo parsing library"
 :upstream_url "https://github.com/mauke/unibilium"
 :source {:url "https://github.com/mauke/unibilium/archive/v1.2.0.tar.gz" :sha256 "623af1099515e673abfd3cae5f2fa808a09ca55dda1c65a7b5c9424eb304ead8"}
 :deps ["karate/glibc"]
 :build_deps ["karate/gcc" "karate/libtool" "karate/make" "karate/perl"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["make" (.. "PREFIX=" b.prefix)]))
 :install (fn [b]
          (b:run ["make" "install" (.. "PREFIX=" b.prefix)]))}
