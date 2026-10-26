;; man-pages, ported from its plan.sh.
;; man-pages 6.20, the latest release on 2026-10-26: 4.02's source no longer downloads.
{:name "man-pages"
 :origin "karate"
 :version "6.20"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["gplv2"]
 :source {:url "https://www.kernel.org/pub/linux/docs/man-pages/man-pages-6.20.tar.xz" :sha256 "180f0d16a2142dd9671760ac0afeadcc25e861f695eb420293e1206a87ca083f"}
 :build_deps ["karate/coreutils" "karate/make"]
 :build (fn [b]
          nil)
 :install (fn [b]
          (b:run ["make" "install" (.. "prefix=" b.prefix)]))}
