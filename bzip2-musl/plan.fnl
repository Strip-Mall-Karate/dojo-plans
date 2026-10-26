;; bzip2-musl, ported from its plan.sh.
;; bzip2-musl 1.0.8, the latest release on 2026-10-26.
;; Built from the bzip2 plan, with its own changes.
(fn v--common-prepare [b]
  (let [text (b:read (b:join b.src "Makefile")) ends (= (text:sub -1) "\n") lines [] out []]
    (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
    (each [n l (ipairs lines)]
      (var line l) (var deleted false) (local after [])
      (when (not deleted) (set line (pick-values 1 (string.gsub line "(ln %-s %-f )$%(PREFIX%)/bin/" "%1" 1))))
      (when (not deleted) (table.insert out line))
      (each [_ x (ipairs after)] (table.insert out x)))
    (b:write (b:join b.src "Makefile") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" ""))))
  (let [text (b:read (b:join b.src "Makefile")) ends (= (text:sub -1) "\n") lines [] out []]
    (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
    (each [n l (ipairs lines)]
      (var line l) (var deleted false) (local after [])
      (when (not deleted) (set line (pick-values 1 (string.gsub line "%(PREFIX%)/man" "(PREFIX)/share/man"))))
      (when (not deleted) (table.insert out line))
      (each [_ x (ipairs after)] (table.insert out x)))
    (b:write (b:join b.src "Makefile") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" "")))))
{:name "bzip2-musl"
 :origin "karate"
 :version "1.0.8"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["bzip2"]
 :description "bzip2 is a free and open-source file compression program that uses the Burrows–Wheeler algorithm. It only compresses single files and is not a file archiver."
 :upstream_url "http://www.bzip.org/"
 :source {:url "https://sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz" :sha256 "ab5a03176ee106d3f0fa90e381da478ddae405918153cca248e682cd0c4a2269" :dirname "bzip2-1.0.8"}
 :deps ["karate/musl"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :prepare (fn [b]
          (var v-dynamic-linker "")
          (v--common-prepare b)
          (b:env "CC" "musl-gcc")
          (b:log (.. "Setting CC=" (or (b:getenv "CC") "")))
          (set v-dynamic-linker (.. (b:path_for "musl") "/lib/ld-musl-x86_64.so.1"))
          (b:env "LDFLAGS" (.. (or (b:getenv "LDFLAGS") "") " -Wl,--dynamic-linker=" v-dynamic-linker)))
 :build (fn [b]
          (b:run ["make" "-f" "Makefile-libbz2_so" (.. "PREFIX=" b.prefix) (.. "CC=" (or (b:getenv "CC") ""))])
          (b:run ["make" "bzip2" "bzip2recover" (.. "CC=" (or (b:getenv "CC") "")) (.. "LDFLAGS=" (or (b:getenv "LDFLAGS") ""))]))
 :check (fn [b]
          (b:run ["make" "test"]))
 :install (fn [b]
          (var v-maj "")
          (var v-maj-min "")
          (set v-maj "1")
          (set v-maj-min "1.0")
          (b:run ["make" "install" (.. "PREFIX=" b.prefix)])
          (b:remove (.. b.prefix "/bin/bunzip2"))
          (b:remove (.. b.prefix "/bin/bzcat"))
          (let [link (if (b:exists (b:join (.. b.prefix "/bin/bunzip2") ".")) (b:join (.. b.prefix "/bin/bunzip2") "bzip2") (.. b.prefix "/bin/bunzip2"))]
            (b:symlink "bzip2" link))
          (let [link (if (b:exists (b:join (.. b.prefix "/bin/bzcat") ".")) (b:join (.. b.prefix "/bin/bzcat") "bzip2") (.. b.prefix "/bin/bzcat"))]
            (b:symlink "bzip2" link))
          (if (b:exists (.. b.prefix "/lib"))
            (b:copy (.. b.cache "/bzip2-1.0.8/libbz2.so." b.version) (b:join (.. b.prefix "/lib") (: (.. b.cache "/bzip2-1.0.8/libbz2.so." b.version) :match "[^/]+$")))
            (b:copy (.. b.cache "/bzip2-1.0.8/libbz2.so." b.version) (.. b.prefix "/lib")))
          (let [link (if (b:exists (b:join (.. b.prefix "/lib/libbz2.so") ".")) (b:join (.. b.prefix "/lib/libbz2.so") (: (.. "libbz2.so." b.version) :match "[^/]+$")) (.. b.prefix "/lib/libbz2.so"))]
            (b:symlink (.. "libbz2.so." b.version) link))
          (let [link (if (b:exists (b:join (.. b.prefix "/lib/libbz2.so." v-maj) ".")) (b:join (.. b.prefix "/lib/libbz2.so." v-maj) (: (.. "libbz2.so." b.version) :match "[^/]+$")) (.. b.prefix "/lib/libbz2.so." v-maj))]
            (b:symlink (.. "libbz2.so." b.version) link))
          (let [link (if (b:exists (b:join (.. b.prefix "/lib/libbz2.so." v-maj-min) ".")) (b:join (.. b.prefix "/lib/libbz2.so." v-maj-min) (: (.. "libbz2.so." b.version) :match "[^/]+$")) (.. b.prefix "/lib/libbz2.so." v-maj-min))]
            (b:symlink (.. "libbz2.so." b.version) link)))}
