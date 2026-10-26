;; fontconfig, ported from its plan.sh.
{:name "fontconfig"
 :origin "karate"
 :version "2.11.95"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["fontconfig"]
 :description "Fontconfig is a library for configuring and\ncustomizing font access."
 :upstream_url "https://www.freedesktop.org/wiki/Software/fontconfig/"
 :source {:url "https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.11.95.tar.bz2" :sha256 "7b165eee7aa22dcc1557db56f58d905b6a14b32f9701c79427452474375b4c89" :filename "fontconfig-2.11.95.tar.bz2"}
 :deps ["karate/bzip2" "karate/glibc" "karate/zlib" "karate/freetype" "karate/libpng" "karate/expat" "karate/gcc-libs"]
 :build_deps ["karate/gcc" "karate/make" "karate/coreutils" "karate/python" "karate/pkg-config" "karate/diffutils" "karate/libtool" "karate/m4" "karate/automake" "karate/autoconf" "karate/file" "karate/patch"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :prepare (fn [b]
          (var v--file-path "")
          (var v--uname-path "")
          (b:env "FREETYPE_CFLAGS" (or (b:getenv "CFLAGS") ""))
          (b:log (.. "Setting FREETYPE_CFLAGS=" (or (b:getenv "FREETYPE_CFLAGS") "")))
          (b:env "FREETYPE_LIBS" (.. (or (b:getenv "LDFLAGS") "") " -Wl,--rpath -Wl," (b:path_for "freetype") "/lib -lfreetype -lz"))
          (b:log (.. "Setting FREETYPE_LIBS=" (or (b:getenv "FREETYPE_LIBS") "")))
          (b:env "CFLAGS" (.. (or (b:getenv "CFLAGS") "") " -I" (b:path_for "freetype") "/include/freetype2"))
          (b:log (.. "Setting CFLAGS=" (or (b:getenv "CFLAGS") "")))
          (b:run ["autoreconf" "-fi"])
          (set v--file-path (.. (b:path_for "file") "/bin/file"))
          (set v--uname-path (.. (b:path_for "coreutils") "/bin/uname"))
          (let [text (b:read (b:join b.src "configure")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line "/usr/bin/file" (pick-values 1 (: v--file-path :gsub "%%" "%%%%"))))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join b.src "configure") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" ""))))
          (let [text (b:read (b:join b.src "configure")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line "/usr/bin/uname" (pick-values 1 (: v--uname-path :gsub "%%" "%%%%"))))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join b.src "configure") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" ""))))
          (b:run ["patch" "-p1" "-i" (.. b.plan_dir "/glibc-2.25+.patch")]))
 :build (fn [b]
          (b:run ["./configure" (.. "--sysconfdir=" b.prefix "/etc") (.. "--prefix=" b.prefix) "--disable-static" (.. "--mandir=" b.prefix "/man")])
          (b:run ["make"]))}
