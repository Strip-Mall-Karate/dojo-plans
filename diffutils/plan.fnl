;; diffutils, ported from its plan.sh.
{:name "diffutils"
 :origin "karate"
 :version "3.6"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["gplv3+"]
 :description "GNU Diffutils is a package of several programs related to finding differences between files."
 :upstream_url "https://www.gnu.org/software/diffutils"
 :source {:url "http://ftp.gnu.org/gnu/diffutils/diffutils-3.6.tar.xz" :sha256 "d621e8bdd4b573918c8145f7ae61817d1be9deb4c8d2328a65cea8e11d783bd6"}
 :deps ["karate/glibc"]
 :build_deps ["karate/coreutils" "karate/patch" "karate/make" "karate/gcc" "karate/sed"]
 :bin_dirs ["bin"]
 :build (fn [b]
          (b:write (b:join b.src "config.cache") (.. (if (b:exists (b:join b.src "config.cache")) (b:read (b:join b.src "config.cache")) "") "gl_cv_func_getopt_gnu=yes\n"))
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--cache-file=config.cache"])
          (b:run ["make"]))
 :check (fn [b]
          (let [text (b:read (b:join b.src "build-aux/update-copyright"))] (b:write (b:join b.src "build-aux/update-copyright") (pick-values 1 (string.gsub text "[^\n]+" (fn [l] (var line l) (set line (pick-values 1 (string.gsub line "copyright{" "copyright\\{" 1))) line)))))
          (b:run ["make" "check" (.. "PATH=" (b:capture ["pwd"]) "/src:" (or (b:getenv "PATH") ""))]))}
