;; man-pages, ported from its plan.sh.
{:name "man-pages"
 :origin "karate"
 :version "4.02"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["gplv2"]
 :source {:url "https://www.kernel.org/pub/linux/docs/man-pages/man-pages-4.02.tar.xz" :sha256 "48aacb75d522dd31978682c4fd8bc68e43c9a409bc4c7a126810e7610dff0dd3"}
 :build_deps ["karate/coreutils" "karate/make"]
 :build (fn [b]
          nil)
 :install (fn [b]
          (b:run ["make" "install" (.. "prefix=" b.prefix)]))}
