;; R, ported from its plan.sh.
{:name :R
 :origin :karate
 :version :3.5.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-2.0+]
 :description "R is a free software environment for statistical computing and graphics."
 :upstream_url "https://www.r-project.org"
 :source {:url "https://cran.r-project.org/src/base/R-3/R-3.5.0.tar.gz"
          :sha256 :fd1725535e21797d3d9fea8963d99be0ba4c3aecadcf081b43e261458b416870}
 :deps [:karate/bzip2
        :karate/cairo
        :karate/curl
        :karate/gcc
        :karate/harfbuzz
        :karate/icu
        :karate/expat
        :karate/fontconfig
        :karate/freetype
        :karate/glib
        :karate/libjpeg-turbo
        :karate/liberation-fonts-ttf
        :karate/libpng
        :karate/libtiff
        :karate/pango
        :karate/pcre
        :karate/pixman
        :karate/readline
        :karate/xz
        :karate/zlib]
 :build_deps [:karate/coreutils
              :karate/diffutils
              :karate/file
              :karate/make
              :karate/perl
              :karate/pkg-config
              :karate/texinfo]
 :bin_dirs [:lib64/R/bin]
 :lib_dirs [:lib64/R/lib]
 :include_dirs [:lib64/R/include]
 :build (fn [b]
          (let [text (b:read (b:join b.src :configure))
                ends (= (text:sub -1) "\n")
                lines []
                out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")]
              (table.insert lines l))
            (each [_n l (ipairs lines)]
              (local line l)
              (var deleted false)
              (local after [])
              (when (not deleted)
                (when (string.find line "#include.*<cairo%-xlib.h>")
                  (set deleted true)))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join b.src :configure)
                     (.. (table.concat out "\n")
                         (if (and ends (> (length out) 0))
                             "\n"
                             ""))))
          (b:run [:./configure
                  (.. :--prefix= b.prefix)
                  :--with-x=no
                  :--disable-java
                  :--enable-memory-profiling])
          (b:run [:make]))
 :check (fn [b]
          (b:run [:make :test]))}
