;; hspec-discover, ported from its plan.sh.
;; The plan's do_clean is not ported: a build empties its source directory before
;; unpacking and starts with no state from an earlier one.
{:name :hspec-discover
 :origin :karate
 :version :2.7.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "Automatically discover and run Hspec tests"
 :upstream_url "https://hspec.github.io/"
 :source {:url "https://hackage.haskell.org/package/hspec-discover-2.7.0/hspec-discover-2.7.0.tar.gz"
          :sha256 :1cb6d6cd494a191b74aa54465005929c73911bf8cd79bb8f7773f4611bf06bd8}
 :deps [:karate/glibc :karate/gmp :karate/libffi]
 :build_deps [:karate/cabal-install :karate/ghc]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :build (fn [b]
          (b:run [:cabal :v1-sandbox :init])
          (b:run [:cabal :v1-update])
          (b:run [:cabal :v1-install :--only-dependencies :--enable-tests])
          (b:run [:cabal
                  :v1-configure
                  (.. :--prefix= b.prefix)
                  :--disable-executable-dynamic
                  :--disable-shared])
          (b:run [:cabal :v1-build]))
 :check (fn [b]
          (b:run [:cabal :v1-test]))
 :install (fn [b]
            (b:run [:cabal :v1-copy]))}
