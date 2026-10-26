;; less, ported from its plan.sh.
;; less 710, the latest release on 2026-10-26.
{:name "less"
 :origin "karate"
 :version "710"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["gplv3+"]
 :description "A terminal pager program used to view (but not change) the contents of a text file."
 :upstream_url "http://www.greenwoodsoftware.com/less/index.html"
 :source {:url "https://www.greenwoodsoftware.com/less/less-710.tar.gz" :sha256 "d1008fb78dcae1323ddab664bcb352a61f022b1b131bd8018548e021d975ec7a"}
 :deps ["karate/glibc" "karate/ncurses" "karate/pcre"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc"]
 :bin_dirs ["bin"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--sysconfdir=/etc" "--with-regex=pcre"])
          (b:run ["make"]))}
