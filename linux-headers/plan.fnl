;; linux-headers, ported from its plan.sh.
{:name "linux-headers"
 :origin "karate"
 :version "4.17.12"
 :targets ["x86_64-linux" "x86_64-linux-kernel2"]
 :maintainer "Strip Mall Karate Company"
 :license ["gplv2"]
 :description "The Linux kernel headers"
 :upstream_url "https://kernel.org"
 :source {:url "https://www.kernel.org/pub/linux/kernel/v4.x/linux-4.17.12.tar.xz" :sha256 "c098e2e4dcb64f8e3fb5cec35e872ff383edefa18532744ddf35bbba829cb5a3" :dirname "linux-4.17.12"}
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["make" "headers_install" "ARCH=x86" (.. "INSTALL_HDR_PATH=" b.prefix)]))
 :install (fn [b]
          (each [_ pattern (ipairs ["..install.cmd" ".install"])]
            (each [_ f (ipairs (b:find (b:join b.prefix "include") pattern))]
              (b:remove f))))
 :on {"x86_64-linux-kernel2"
      {:version "2.6.39"
       :license ["gplv2"]
       :description "The Linux kernel headers"
       :upstream_url "https://kernel.org"
       :source {:url "https://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.39.tar.xz" :sha256 "d3a579104e0d3154727793f4fa79b6b882ddafeded73cc8c0eb8c2536ad77373" :dirname "linux-2.6.39"}
       :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/perl"]
       :include_dirs ["include"]
       :build (fn [b]
          (b:run ["make" "headers_install" "ARCH=x86" (.. "INSTALL_HDR_PATH=" b.prefix)]))
       :install (fn [b]
          (each [_ pattern (ipairs ["..install.cmd" ".install"])]
            (each [_ f (ipairs (b:find (b:join b.prefix "include") pattern))]
              (b:remove f))))}}}
