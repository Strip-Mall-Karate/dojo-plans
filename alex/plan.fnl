;; alex, ported from its plan.sh.
;; The plan's do_clean is not ported: a build empties its source directory before
;; unpacking and starts with no state from an earlier one.
{:name :alex
 :origin :karate
 :version :3.2.4
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:BSD-3-Clause]
 :description "Alex is a tool for generating lexical analysers in Haskell. It takes a description of tokens based on regular expressions and generates a Haskell module containing code for scanning text efficiently. It is similar to the tool lex or flex for C/C++."
 :upstream_url "http://www.haskell.org/alex/"
 :source {:url "https://hackage.haskell.org/package/alex-3.2.4/alex-3.2.4.tar.gz"
          :sha256 :d58e4d708b14ff332a8a8edad4fa8989cb6a9f518a7c6834e96281ac5f8ff232}
 :deps [:karate/glibc :karate/gmp :karate/libffi]
 :build_deps [:karate/cabal-install :karate/ghc :karate/make :karate/which]
 :bin_dirs [:bin]
 :build (fn [b]
          (b:run [:cabal :v1-sandbox :init])
          (b:run [:cabal :v1-update])
          (b:run [:cabal :v1-install :--only-dependencies])
          (b:run [:cabal :v1-configure (.. :--prefix= b.prefix)])
          (b:run [:cabal :v1-build]))
 :check (fn [b]
          (b:env :PATH (.. b.src "/dist/build/alex:" (or (b:getenv :PATH) "")))
          (b:run [:cabal :v1-test]))
 :install (fn [b]
            (b:run [:cabal :v1-copy]))}
