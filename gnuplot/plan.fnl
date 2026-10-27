;; gnuplot, ported from its plan.sh.
{:name :gnuplot
 :origin :karate
 :version :5.2.6
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:gnuplot]
 :description "Gnuplot is a portable command-line driven graphing
utility for Linux, OS/2, MS Windows, OSX, VMS, and many other
platforms"
 :upstream_url "http://www.gnuplot.info"
 :source {:url "https://sourceforge.net/projects/gnuplot/files/gnuplot/5.2.6/gnuplot-5.2.6.tar.gz"
          :sha256 :35dd8f013139e31b3028fac280ee12d4b1346d9bb5c501586d1b5a04ae7a94ee}
 :deps [:karate/bzip2
        :karate/cairo
        :karate/expat
        :karate/fontconfig
        :karate/freetype
        :karate/gcc-libs
        :karate/glib
        :karate/glibc
        :karate/harfbuzz
        :karate/jbigkit
        :karate/libcerf
        :karate/liberation-fonts-ttf
        :karate/libffi
        :karate/libice
        :karate/libiconv
        :karate/libgd
        :karate/libjpeg-turbo
        :karate/libpng
        :karate/libsm
        :karate/libtiff
        :karate/libxau
        :karate/libxcb
        :karate/libxdmcp
        :karate/libxext
        :karate/ncurses
        :karate/pango
        :karate/pcre
        :karate/pixman
        :karate/readline
        :karate/xlib
        :karate/xz
        :karate/zlib]
 :build_deps [:karate/gcc :karate/make :karate/patch :karate/pkg-config]
 :bin_dirs [:bin]
 :prepare (fn [b]
            (b:run [:patch
                    :-p1
                    :-i
                    (.. b.plan_dir :/patches/configure-using-pkgconfig.patch)]))
 :check (fn [b]
          (b:run [:make :check]))}
