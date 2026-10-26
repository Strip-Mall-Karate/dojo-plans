;; ncurses5, ported from its plan.sh.
;; Built from the ncurses plan, with its own changes.
{:name "ncurses5"
 :origin "karate"
 :version "6.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["ncurses"]
 :description "The ncurses (new curses) library with version 5 API"
 :upstream_url "https://www.gnu.org/software/ncurses/"
 :source {:url "http://ftp.gnu.org/gnu/ncurses/ncurses-6.1.tar.gz" :sha256 "aa057eeeb4a14d470101eff4597d5833dcef5965331be3528c08d99cebaa0d17" :filename "ncurses-6.1.tar.gz" :dirname "ncurses-6.1"}
 :deps ["karate/glibc" "karate/gcc-libs"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/bzip2"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--with-shared" "--with-termlib" "--with-cxx-binding" "--with-cxx-shared" "--without-ada" "--enable-sigwinch" "--enable-pc-files" (.. "--with-pkg-config-libdir=" b.prefix "/lib/pkgconfig") "--enable-symlinks" "--enable-widec" "--without-debug" "--with-normal" "--enable-overwrite" "--disable-rpath-hack" "--with-abi-version=5"])
          (b:run ["make"]))
 :install (fn [b]
          (b:run ["make" "install"])
          (each [_ v-x (ipairs ["curses" "ncurses" "form" "panel" "menu" "tinfo"])]
            (b:symlink (.. "lib" v-x "w.so") (.. b.prefix "/lib/lib" v-x ".so")) (b:symlink (.. "lib" v-x "w.so") (.. b.prefix "/lib/lib" v-x ".so.5")) (b:symlink (.. v-x "w.pc") (.. b.prefix "/lib/pkgconfig/" v-x ".pc")))
          (b:remove (.. b.prefix "/lib/libcursesw.so"))
          (b:symlink "libncursesw.so" (.. b.prefix "/lib/libcursesw.so"))
          (b:remove (.. b.prefix "/lib/libcursesw.a"))
          (b:symlink "libncursesw.a" (.. b.prefix "/lib/libcursesw.a"))
          (b:remove (.. b.prefix "/lib/libcurses.a"))
          (b:symlink "libncursesw.a" (.. b.prefix "/lib/libcurses.a"))
          (b:mkdir (.. b.prefix "/share/licenses"))
          (b:write (.. b.prefix "/share/licenses/LICENSE") (.. (b:capture ["grep" "-B" "100" "$Id" "README"]) "\n")))}
