;; ncurses5, ported from its plan.sh.
;; Built from the ncurses plan, with its own changes.
{:name :ncurses5
 :origin :karate
 :version :6.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:ncurses]
 :description "The ncurses (new curses) library with version 5 API"
 :upstream_url "https://www.gnu.org/software/ncurses/"
 :source {:url "http://ftp.gnu.org/gnu/ncurses/ncurses-6.1.tar.gz"
          :sha256 :aa057eeeb4a14d470101eff4597d5833dcef5965331be3528c08d99cebaa0d17
          :filename :ncurses-6.1.tar.gz
          :dirname :ncurses-6.1}
 :deps [:karate/glibc :karate/gcc-libs]
 :build_deps [:karate/coreutils
              :karate/diffutils
              :karate/patch
              :karate/make
              :karate/gcc
              :karate/bzip2]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :build (fn [b]
          (b:run [:./configure
                  (.. :--prefix= b.prefix)
                  :--with-shared
                  :--with-termlib
                  :--with-cxx-binding
                  :--with-cxx-shared
                  :--without-ada
                  :--enable-sigwinch
                  :--enable-pc-files
                  (.. :--with-pkg-config-libdir= b.prefix :/lib/pkgconfig)
                  :--enable-symlinks
                  :--enable-widec
                  :--without-debug
                  :--with-normal
                  :--enable-overwrite
                  :--disable-rpath-hack
                  :--with-abi-version=5])
          (b:run [:make]))
 :install (fn [b]
            (b:run [:make :install])
            (each [_ v-x (ipairs [:curses :ncurses :form :panel :menu :tinfo])]
              (let [link (if (b:exists (b:join (.. b.prefix :/lib/lib v-x :.so)
                                               "."))
                             (b:join (.. b.prefix :/lib/lib v-x :.so)
                                     (: (.. :lib v-x :w.so) :match "[^/]+$"))
                             (.. b.prefix :/lib/lib v-x :.so))]
                (b:symlink (.. :lib v-x :w.so) link))
              (let [link (if (b:exists (b:join (.. b.prefix :/lib/lib v-x
                                                   :.so.5)
                                               "."))
                             (b:join (.. b.prefix :/lib/lib v-x :.so.5)
                                     (: (.. :lib v-x :w.so) :match "[^/]+$"))
                             (.. b.prefix :/lib/lib v-x :.so.5))]
                (b:symlink (.. :lib v-x :w.so) link))
              (let [link (if (b:exists (b:join (.. b.prefix :/lib/pkgconfig/
                                                   v-x :.pc)
                                               "."))
                             (b:join (.. b.prefix :/lib/pkgconfig/ v-x :.pc)
                                     (: (.. v-x :w.pc) :match "[^/]+$"))
                             (.. b.prefix :/lib/pkgconfig/ v-x :.pc))]
                (b:symlink (.. v-x :w.pc) link)))
            (let [link (if (b:exists (b:join (.. b.prefix :/lib/libcursesw.so)
                                             "."))
                           (b:join (.. b.prefix :/lib/libcursesw.so)
                                   :libncursesw.so)
                           (.. b.prefix :/lib/libcursesw.so))]
              (b:remove link)
              (b:symlink :libncursesw.so link))
            (let [link (if (b:exists (b:join (.. b.prefix :/lib/libcursesw.a)
                                             "."))
                           (b:join (.. b.prefix :/lib/libcursesw.a)
                                   :libncursesw.a)
                           (.. b.prefix :/lib/libcursesw.a))]
              (b:remove link)
              (b:symlink :libncursesw.a link))
            (let [link (if (b:exists (b:join (.. b.prefix :/lib/libcurses.a)
                                             "."))
                           (b:join (.. b.prefix :/lib/libcurses.a)
                                   :libncursesw.a)
                           (.. b.prefix :/lib/libcurses.a))]
              (b:remove link)
              (b:symlink :libncursesw.a link))
            (b:mkdir (.. b.prefix :/share/licenses))
            (b:write (.. b.prefix :/share/licenses/LICENSE)
                     (.. (b:capture [:grep :-B :100 :$Id :README]) "\n")))}
