;; libtool, ported from its plan.sh.
{:name "libtool"
 :origin "karate"
 :version "2.4.6"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["gplv2+"]
 :description "GNU libtool is a generic library support script. Libtool hides the complexity of using shared libraries behind a consistent, portable interface."
 :upstream_url "http://www.gnu.org/software/libtool"
 :source {:url "http://ftp.gnu.org/gnu/libtool/libtool-2.4.6.tar.gz" :sha256 "e3bd4d5d3d025a36c21dd6af7ea818a2afcd4dfc1ea5a17b39d7854bcd0c06e3" :filename "libtool-2.4.6.tar.gz"}
 :deps ["karate/glibc" "karate/coreutils" "karate/sed" "karate/grep" "karate/binutils"]
 :build_deps ["karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/m4"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :prepare (fn [b]
          (b.default.prepare b)
          ;; The plan named $(libtoolize_1), which no plan defines, so the shell put nothing
          ;; there: the man page is dropped, and help2man with it.
          (let [text (b:read (b:join b.src "Makefile.in"))]
            (b:write (b:join b.src "Makefile.in")
                     (pick-values 1 (: text :gsub "\ndist_man1_MANS =[^\n]*" "\ndist_man1_MANS = ")))))
 :build (fn [b]
          (var v-lt-cv-sys-lib-dlsearch-path-spec "")
          (var v-lt-cv-sys-lib-search-path-spec "")
          (b:run ["./configure" (.. "--prefix=" b.prefix) "lt_cv_sys_lib_dlsearch_path_spec=" "lt_cv_sys_lib_search_path_spec="])
          (b:run ["make"]))}
