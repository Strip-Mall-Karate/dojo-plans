;; cabal-install, ported from its plan.sh.
;; The plan's do_clean is not ported: a build empties its source directory before
;; unpacking and starts with no state from an earlier one.
{:name :cabal-install
 :origin :karate
 :version :2.4.1.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:BSD-3-Clause]
 :description "Command-line interface for Cabal and Hackage"
 :upstream_url "https://www.haskell.org/cabal/"
 :source {:url "https://www.haskell.org/cabal/release/cabal-install-2.4.1.0/cabal-install-2.4.1.0.tar.gz"
          :sha256 :69bcb2b54a064982412e1587c3c5c1b4fada3344b41b568aab25730034cb21ad}
 :deps [:karate/gcc-libs :karate/glibc :karate/gmp :karate/libffi :karate/zlib]
 :build_deps [:karate/curl :karate/ghc :karate/sed :karate/which]
 :bin_dirs [:bin]
 :build (fn [b]
          (b:run [:./bootstrap.sh :--sandbox]
                 {:env {:EXTRA_CONFIGURE_OPTS (.. :--extra-include-dirs=
                                                  (b:path_for :zlib)
                                                  "/include --extra-lib-dirs="
                                                  (b:path_for :zlib) :/lib)}}))
 :check (fn [b]
          (b:run [:.cabal-sandbox/bin/cabal :update])
          (b:run [:.cabal-sandbox/bin/cabal :info :cabal]))
 :install (fn [b]
            (if (b:exists (.. b.prefix :/bin))
                (b:copy (b:join b.src :.cabal-sandbox/bin/cabal)
                        (b:join (.. b.prefix :/bin)
                                (: (b:join b.src :.cabal-sandbox/bin/cabal)
                                   :match "[^/]+$")))
                (b:copy (b:join b.src :.cabal-sandbox/bin/cabal)
                        (.. b.prefix :/bin))))}
