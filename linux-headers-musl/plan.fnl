;; linux-headers-musl, ported from its plan.sh.
;; linux-headers-musl 4.19.88-2, the latest release on 2026-10-26.
{:name "linux-headers-musl"
 :origin "karate"
 :version "4.19.88-2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "Linux kernel headers (sanitized for use with musl)."
 :upstream_url "https://github.com/sabotage-linux/kernel-headers"
 :source {:url "https://github.com/sabotage-linux/kernel-headers/releases/download/v4.19.88-2/linux-headers-4.19.88-2.tar.xz" :sha256 "dc7abf734487553644258a3822cfd429d74656749e309f2b25f09f4282e05588" :dirname "linux-headers-4.19.88-2"}
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/gcc" "karate/make" "karate/patch"]
 :include_dirs ["include"]
 :build (fn [b]
          (var v-prefix "")
          (b:run ["make" "ARCH=x86_64" (.. "prefix=" b.prefix)]))
 :install (fn [b]
          (var v-prefix "")
          (b:run ["make" "ARCH=x86_64" (.. "prefix=" b.prefix) "install"]))}
