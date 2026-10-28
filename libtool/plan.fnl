;; libtool, ported from its plan.sh.
;; libtool 2.6.2, the latest release on 2026-10-26.
{:name :libtool
 :origin :karate
 :version :2.6.2
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:gplv2+]
 :description "GNU libtool is a generic library support script. Libtool hides the complexity of using shared libraries behind a consistent, portable interface."
 :upstream_url "http://www.gnu.org/software/libtool"
 :source {:url "https://ftp.gnu.org/gnu/libtool/libtool-2.6.2.tar.xz"
          :sha256 :2ef1067c16c97db930fd740cc9bc3d3ba9a583804ae5ac42cc3e8719e49e191e
          :filename :libtool-2.6.2.tar.xz}
 :deps [:karate/glibc
        :karate/coreutils
        :karate/sed
        :karate/grep
        :karate/binutils]
 :build_deps [:karate/diffutils
              :karate/patch
              :karate/make
              :karate/gcc
              :karate/m4]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :prepare (fn [b]
            (b.default.prepare b)
            ;; Plans that build with it find its m4 macros: aclocal reads ACLOCAL_PATH.
            (b:buildtime_env_push :ACLOCAL_PATH (.. b.prefix :/share/aclocal))
            ;; The plan named $(libtoolize_1), which no plan defines, so the shell put nothing
            ;; there: the man page is dropped, and help2man with it.
            (let [text (b:read (b:join b.src :Makefile.in))]
              (b:write (b:join b.src :Makefile.in) (pick-values 1
                                                                (text:gsub "
dist_man1_MANS =[^
]*"
                                                                           "
dist_man1_MANS = ")))))
 :build (fn [b]
          (b:run [:./configure
                  (.. :--prefix= b.prefix)
                  :lt_cv_sys_lib_dlsearch_path_spec=
                  :lt_cv_sys_lib_search_path_spec=])
          (b:run [:make]))}
