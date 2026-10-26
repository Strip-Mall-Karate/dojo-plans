;; ncurses, ported from its plan.sh.
{:name "ncurses"
 :origin "karate"
 :version "6.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["ncurses"]
 :description "ncurses (new curses) is a programming library providing an application programming interface (API) that allows the programmer to write text-based user interfaces in a terminal-independent manner."
 :upstream_url "https://www.gnu.org/software/ncurses/"
 :source {:url "http://ftp.gnu.org/gnu/ncurses/ncurses-6.1.tar.gz" :sha256 "aa057eeeb4a14d470101eff4597d5833dcef5965331be3528c08d99cebaa0d17"}
 :deps ["karate/glibc" "karate/gcc-libs"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/bzip2"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--with-shared" "--with-termlib" "--with-cxx-binding" "--with-cxx-shared" "--without-ada" "--enable-sigwinch" "--enable-pc-files" (.. "--with-pkg-config-libdir=" b.prefix "/lib/pkgconfig") "--enable-symlinks" "--enable-widec" "--enable-ext-colors" "--without-debug" "--with-normal" "--enable-overwrite" "--disable-rpath-hack"])
          (b:run ["make"]))
 :install (fn [b]
          (var v-maj "")
          (var v-maj-min "")
          (b:run ["make" "install"])
          (set v-maj "6")
          (set v-maj-min "6.1")
          (each [_ v-x (ipairs ["curses" "ncurses" "form" "panel" "menu" "tinfo"])]
            (b:symlink (.. "lib" v-x "w.so") (.. b.prefix "/lib/lib" v-x ".so")) (b:symlink (.. "lib" v-x "w.so") (.. b.prefix "/lib/lib" v-x ".so." v-maj)) (b:symlink (.. "lib" v-x "w.so") (.. b.prefix "/lib/lib" v-x ".so." v-maj-min)) (b:symlink (.. v-x "w.pc") (.. b.prefix "/lib/pkgconfig/" v-x ".pc")))
          (b:remove (.. b.prefix "/lib/libcursesw.so"))
          (b:symlink "libncursesw.so" (.. b.prefix "/lib/libcursesw.so"))
          (b:remove (.. b.prefix "/lib/libcursesw.a"))
          (b:symlink "libncursesw.a" (.. b.prefix "/lib/libcursesw.a"))
          (b:remove (.. b.prefix "/lib/libcurses.a"))
          (b:symlink "libncursesw.a" (.. b.prefix "/lib/libcurses.a"))
          (b:mkdir (.. b.prefix "/share/licenses"))
          (b:write (.. b.prefix "/share/licenses/LICENSE") (.. (b:capture ["grep" "-B" "100" "$Id" "README"]) "\n")))}
