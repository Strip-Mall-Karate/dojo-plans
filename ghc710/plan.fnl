;; ghc710, ported from its plan.sh.
;; Built from the ghc plan, with its own changes.
{:name "ghc710"
 :origin "karate"
 :version "7.10.3"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["BSD-3-Clause"]
 :description "The Glasgow Haskell Compiler"
 :upstream_url "https://www.haskell.org/ghc/"
 :source {:url "http://downloads.haskell.org/~ghc/7.10.3/ghc-7.10.3b-src.tar.xz" :sha256 "06c6c20077dc3cf7ea3f40126b2128ce5ab144e1fa66fd1c05ae1ade3dfaa8e5" :dirname "ghc-7.10.3"}
 :deps ["karate/gcc" "karate/glibc" "karate/gmp" "karate/libedit" "karate/ncurses" "karate/perl"]
 :build_deps ["karate/binutils" "karate/diffutils" "karate/ghc710-bootstrap" "karate/libffi" "karate/make" "karate/patch" "karate/sed"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["lib/ghc-7.10.3/include"]
 :interpreters ["bin/runhaskell" "bin/runghc"]
 :prepare (fn [b]
          (b.default.prepare b)
          (var v-ld (.. (b:path_for "binutils") "/bin/ld"))
          (b:env "LD" v-ld)
          (b:log (.. "Updating LD=" v-ld))
          (var v-library-path (.. (or (b:getenv "LIBRARY_PATH") "") ":" (or (b:getenv "LD_RUN_PATH") "")))
          (b:env "LIBRARY_PATH" v-library-path)
          (b:log (.. "Updating LIBRARY_PATH=" v-library-path))
          (if (b:exists (b:join b.src "mk/build.mk"))
            (b:copy (b:join b.src "mk/build.mk.sample") (b:join (b:join b.src "mk/build.mk") (: (b:join b.src "mk/build.mk.sample") :match "[^/]+$")))
            (b:copy (b:join b.src "mk/build.mk.sample") (b:join b.src "mk/build.mk")))
          (let [text (b:read (b:join b.src "mk/build.mk")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (when (= n 1) (table.insert out "BuildFlavour = perf")))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join b.src "mk/build.mk") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" "")))))
 :build (fn [b]
          (b:env "LD_LIBRARY_PATH" (.. (or (b:getenv "LD_LIBRARY_PATH") "") ":" (b:path_for "gmp") "/lib:" (b:path_for "ncurses") "/lib:" (b:path_for "libffi") "/lib"))
          (b:run ["./configure" (.. "--prefix=" b.prefix) (.. "--with-curses-includes=" (b:path_for "ncurses") "/include") (.. "--with-curses-libraries=" (b:path_for "ncurses") "/lib") (.. "--with-gmp-includes=" (b:path_for "gmp") "/include") (.. "--with-gmp-libraries=" (b:path_for "gmp") "/lib")])
          (b:run ["make"]))}
