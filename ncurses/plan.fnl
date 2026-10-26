;; ncurses, ported from its plan.sh.
;; ncurses 6.6, the latest release on 2026-10-26.
{:name "ncurses"
 :origin "karate"
 :version "6.6"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["ncurses"]
 :description "ncurses (new curses) is a programming library providing an application programming interface (API) that allows the programmer to write text-based user interfaces in a terminal-independent manner."
 :upstream_url "https://www.gnu.org/software/ncurses/"
 :source {:url "https://ftp.gnu.org/gnu/ncurses/ncurses-6.6.tar.gz" :sha256 "355b4cbbed880b0381a04c46617b7656e362585d52e9cf84a67e2009b749ff11"}
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
          (set v-maj-min "6.6")
          (each [_ v-x (ipairs ["curses" "ncurses" "form" "panel" "menu" "tinfo"])]
            (let [link (if (b:exists (b:join (.. b.prefix "/lib/lib" v-x ".so") ".")) (b:join (.. b.prefix "/lib/lib" v-x ".so") (: (.. "lib" v-x "w.so") :match "[^/]+$")) (.. b.prefix "/lib/lib" v-x ".so"))]
            (b:symlink (.. "lib" v-x "w.so") link)) (let [link (if (b:exists (b:join (.. b.prefix "/lib/lib" v-x ".so." v-maj) ".")) (b:join (.. b.prefix "/lib/lib" v-x ".so." v-maj) (: (.. "lib" v-x "w.so") :match "[^/]+$")) (.. b.prefix "/lib/lib" v-x ".so." v-maj))]
            (b:symlink (.. "lib" v-x "w.so") link)) (let [link (if (b:exists (b:join (.. b.prefix "/lib/lib" v-x ".so." v-maj-min) ".")) (b:join (.. b.prefix "/lib/lib" v-x ".so." v-maj-min) (: (.. "lib" v-x "w.so") :match "[^/]+$")) (.. b.prefix "/lib/lib" v-x ".so." v-maj-min))]
            (b:symlink (.. "lib" v-x "w.so") link)) (let [link (if (b:exists (b:join (.. b.prefix "/lib/pkgconfig/" v-x ".pc") ".")) (b:join (.. b.prefix "/lib/pkgconfig/" v-x ".pc") (: (.. v-x "w.pc") :match "[^/]+$")) (.. b.prefix "/lib/pkgconfig/" v-x ".pc"))]
            (b:symlink (.. v-x "w.pc") link)))
          (let [link (if (b:exists (b:join (.. b.prefix "/lib/libcursesw.so") ".")) (b:join (.. b.prefix "/lib/libcursesw.so") "libncursesw.so") (.. b.prefix "/lib/libcursesw.so"))]
            (b:remove link) (b:symlink "libncursesw.so" link))
          (let [link (if (b:exists (b:join (.. b.prefix "/lib/libcursesw.a") ".")) (b:join (.. b.prefix "/lib/libcursesw.a") "libncursesw.a") (.. b.prefix "/lib/libcursesw.a"))]
            (b:remove link) (b:symlink "libncursesw.a" link))
          (let [link (if (b:exists (b:join (.. b.prefix "/lib/libcurses.a") ".")) (b:join (.. b.prefix "/lib/libcurses.a") "libncursesw.a") (.. b.prefix "/lib/libcurses.a"))]
            (b:remove link) (b:symlink "libncursesw.a" link))
          (b:mkdir (.. b.prefix "/share/licenses"))
          (b:write (.. b.prefix "/share/licenses/LICENSE") (.. (b:capture ["grep" "-B" "100" "$Id" "README"]) "\n")))}
