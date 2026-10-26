;; happy, ported from its plan.sh.
;; The plan's do_clean is not ported: a build empties its source directory before
;; unpacking and starts with no state from an earlier one.
{:name "happy"
 :origin "karate"
 :version "1.19.9"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["BSD-3-Clause"]
 :description "Happy is a parser generator for Haskell. Given a grammar specification in BNF, Happy generates Haskell code to parse the grammar. Happy works in a similar way to the yacc tool for C."
 :upstream_url "https://www.haskell.org/happy/"
 :source {:url "https://hackage.haskell.org/package/happy-1.19.9/happy-1.19.9.tar.gz" :sha256 "3e81a3e813acca3aae52721c412cde18b7b7c71ecbacfaeaa5c2f4b35abf1d8d"}
 :deps ["karate/glibc" "karate/gmp" "karate/libffi"]
 :build_deps ["karate/cabal-install" "karate/diffutils" "karate/ghc" "karate/make" "karate/sed"]
 :bin_dirs ["bin"]
 :prepare (fn [b]
          (b:env "LANG" "en_US.utf8")
          (let [text (b:read (b:join b.src "happy.cabal")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line "Cabal <2.2" "Cabal <2.5"))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join b.src "happy.cabal") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" "")))))
 :build (fn [b]
          (b:run ["cabal" "v1-sandbox" "init"])
          (b:run ["cabal" "v1-update"])
          (b:run ["cabal" "v1-install" "--only-dependencies"])
          (b:run ["cabal" "v1-configure" (.. "--prefix=" b.prefix)])
          (b:run ["cabal" "v1-build"]))
 :check (fn [b]
          (b:run ["cabal" "v1-test"]))
 :install (fn [b]
          (b:run ["cabal" "v1-copy"]))}
