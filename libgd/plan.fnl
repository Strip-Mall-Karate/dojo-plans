;; libgd, ported from its plan.sh.
(fn use-dependency-path [b path replacement]
  ;; The source project's studio linked a dependency's tool to `path` for the
  ;; build. A Dojo build writes nothing outside itself, so the build's scripts
  ;; name the dependency's tool instead.
  (each [_ f (ipairs (b:find b.src "*"))]
    (let [name (: f :match "[^/]+$")]
      (when (and (or (: name :match "^configure") (: name :match "^Makefile") (: name :match "^ltmain")
                     (: name :match "%.in$") (: name :match "%.am$") (: name :match "%.ac$")
                     (: name :match "%.m4$") (: name :match "%.mk$") (: name :match "%.sh$")
                     (: name :match "%.pl$") (: name :match "%.py$"))
                 (not (b:exists (b:join f "."))))
        (let [text (b:read f)
              escaped (pick-values 1 (: path :gsub "[%^%$%(%)%%%.%[%]%*%+%-%?]" "%%%0"))
              (fixed n) (: text :gsub escaped (pick-values 1 (: replacement :gsub "%%" "%%%%")))]
          (when (> n 0) (b:write f fixed)))))))
{:name "libgd"
 :origin "karate"
 :version "2.2.4"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["In order to resolve any possible confusion regarding the authorship of\ngd, the following copyright statement covers all of the authors who\nhave required such a statement. If you are aware of any oversights in\nthis copyright notice, please contact Pierre-A. Joye who will be\npleased to correct them.\n\n   Portions copyright 1994, 1995, 1996, 1997, 1998, 1999, 2000, 2001,\n   2002, 2003, 2004 by Cold Spring Harbor Laboratory. Funded under\n   Grant P41-RR02188 by the National Institutes of Health.\n\n   Portions copyright 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2003,\n   2004 by Boutell.Com, Inc.\n\n   Portions relating to GD2 format copyright 1999, 2000, 2001, 2002,\n   2003, 2004 Philip Warner.\n\n   Portions relating to PNG copyright 1999, 2000, 2001, 2002, 2003,\n   2004 Greg Roelofs.\n\n   Portions relating to gdttf.c copyright 1999, 2000, 2001, 2002,\n   2003, 2004 John Ellson (ellson@graphviz.org).\n\n   Portions relating to gdft.c copyright 2001, 2002, 2003, 2004 John\n   Ellson (ellson@graphviz.org).\n\n   Portions copyright 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007\n   Pierre-Alain Joye (pierre@libgd.org).\n\n   Portions relating to JPEG and to color quantization copyright\n   2000, 2001, 2002, 2003, 2004, Doug Becker and copyright (C) 1994,\n   1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004 Thomas\n   G. Lane. This software is based in part on the work of the\n   Independent JPEG Group. See the file README-JPEG.TXT for more\n   information.\n\n   Portions relating to GIF compression copyright 1989 by Jef\n   Poskanzer and David Rowley, with modifications for thread safety\n   by Thomas Boutell.\n\n   Portions relating to GIF decompression copyright 1990, 1991, 1993\n   by David Koblas, with modifications for thread safety by Thomas\n   Boutell.\n\n   Portions relating to WBMP copyright 2000, 2001, 2002, 2003, 2004\n   Maurice Szmurlo and Johan Van den Brande.\n\n   Portions relating to GIF animations copyright 2004 Jaakko Hyvätti\n   (jaakko.hyvatti@iki.fi)\n\nPermission has been granted to copy, distribute and modify gd in\nany context without fee, including a commercial application,\nprovided that this notice is present in user-accessible supporting\ndocumentation.\n\nThis does not affect your ownership of the derived work itself,\nand the intent is to assure proper credit for the authors of gd,\nnot to interfere with your productive use of gd. If you have\nquestions, ask. \"Derived works\" includes all programs that utilize\nthe library. Credit must be given in user-accessible\ndocumentation.\n\nThis software is provided \"AS IS.\" The copyright holders disclaim\nall warranties, either express or implied, including but not\nlimited to implied warranties of merchantability and fitness for a\nparticular purpose, with respect to this code and accompanying\ndocumentation.\n\nAlthough their code does not appear in the current release, the\nauthors also wish to thank Hutchison Avenue Software Corporation\nfor their prior contributions."]
 :description "GD is an open source code library for the dynamic creation of images by programmers."
 :upstream_url "https://libgd.github.io"
 :source {:url "https://github.com/libgd/libgd/releases/download/gd-2.2.4/libgd-2.2.4.tar.xz" :sha256 "137f13a7eb93ce72e32ccd7cebdab6874f8cf7ddf31d3a455a68e016ecd9e4e6"}
 :deps ["karate/fontconfig" "karate/freetype" "karate/libjpeg-turbo" "karate/libpng" "karate/libtiff" "karate/zlib"]
 :build_deps ["karate/diffutils" "karate/file" "karate/gcc" "karate/make" "karate/pkg-config"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :prepare (fn [b]
          (use-dependency-path b "/usr/bin/file" (b:path_for "karate/file" "bin/file")))
 :check (fn [b]
          (b:run ["make" "check"]))
}
