;; less, ported from its plan.sh.
{:name "less"
 :origin "karate"
 :version "530"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["gplv3+"]
 :description "A terminal pager program used to view (but not change) the contents of a text file."
 :upstream_url "http://www.greenwoodsoftware.com/less/index.html"
 :source {:url "http://www.greenwoodsoftware.com/less/less-530.tar.gz" :sha256 "503f91ab0af4846f34f0444ab71c4b286123f0044a4964f1ae781486c617f2e2"}
 :deps ["karate/glibc" "karate/ncurses" "karate/pcre"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc"]
 :bin_dirs ["bin"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--sysconfdir=/etc" "--with-regex=pcre"])
          (b:run ["make"]))}
