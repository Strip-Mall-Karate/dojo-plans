;; bzip2, ported from its plan.sh.
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
{:name "bzip2"
 :origin "karate"
 :version "1.0.6"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["bzip2"]
 :description "bzip2 is a free and open-source file compression program that uses the Burrows–Wheeler algorithm. It only compresses single files and is not a file archiver."
 :upstream_url "http://www.bzip.org/"
 :source {:url "https://github.com/nemequ/bzip2/releases/download/v1.0.6/bzip2-1.0.6.tar.gz" :sha256 "a2848f34fcd5d6cf47def00461fcb528a0484d8edef8208d6d2e2909dc61d9cd" :dirname "bzip2-1.0.6"}
 :deps ["karate/glibc"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :prepare (fn [b]
          (v--common-prepare b)
          (b:env "CC" "gcc")
          (b:log (.. "Setting CC=" (or (b:getenv "CC") ""))))
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
          (b:remove (.. b.prefix "/bin/{bunzip2,bzcat}"))
          (b:symlink "bzip2" (.. b.prefix "/bin/bunzip2"))
          (b:symlink "bzip2" (.. b.prefix "/bin/bzcat"))
          (if (b:exists (.. b.prefix "/lib"))
            (b:copy (.. b.cache "/bzip2-1.0.6/libbz2.so." b.version) (b:join (.. b.prefix "/lib") (: (.. b.cache "/bzip2-1.0.6/libbz2.so." b.version) :match "[^/]+$")))
            (b:copy (.. b.cache "/bzip2-1.0.6/libbz2.so." b.version) (.. b.prefix "/lib")))
          (b:symlink (.. "libbz2.so." b.version) (.. b.prefix "/lib/libbz2.so"))
          (b:symlink (.. "libbz2.so." b.version) (.. b.prefix "/lib/libbz2.so." v-maj))
          (b:symlink (.. "libbz2.so." b.version) (.. b.prefix "/lib/libbz2.so." v-maj-min)))}
