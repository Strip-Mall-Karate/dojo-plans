;; linux-headers-musl, ported from its plan.sh.
{:name "linux-headers-musl"
 :origin "karate"
 :version "3.12.6-6"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "Linux kernel headers (sanitized for use with musl)."
 :upstream_url "https://github.com/sabotage-linux/kernel-headers"
 :source {:url "https://github.com/sabotage-linux/kernel-headers/archive/v3.12.6-6.tar.gz" :sha256 "e173fc8db34660a368c1692b3cea2b8a3b2affb3c193ae7195aa251bc1497d57" :dirname "kernel-headers-3.12.6-6"}
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/gcc" "karate/make" "karate/patch"]
 :include_dirs ["include"]
 :build (fn [b]
          (var v-prefix "")
          (b:run ["make" "ARCH=x86_64" (.. "prefix=" b.prefix)]))
 :install (fn [b]
          (var v-prefix "")
          (b:run ["make" "ARCH=x86_64" (.. "prefix=" b.prefix) "install"]))}
