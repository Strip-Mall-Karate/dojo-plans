;; libdrm, ported from its plan.sh.
{:name "libdrm"
 :origin "karate"
 :version "2.4.88"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "Direct Rendering Manager"
 :upstream_url "https://dri.freedesktop.org/wiki/"
 :source {:url "https://dri.freedesktop.org/libdrm/libdrm-2.4.88.tar.gz" :sha256 "a8b458db6a73c717baee2e249d39511fb6f5c0f5f24dee2770935eddeda1a017"}
 :deps ["karate/libpciaccess" "karate/glibc"]
 :build_deps ["karate/diffutils" "karate/gcc" "karate/libxslt" "karate/make" "karate/pkg-config"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :check (fn [b]
          (b:run ["make" "check"]))}
