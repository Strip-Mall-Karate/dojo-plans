;; ghc82-bootstrap, ported from its plan.sh.
{:name :ghc82-bootstrap
 :origin :karate
 :version :8.2.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:BSD-3-Clause]
 :description "The Glasgow Haskell Compiler - Binary Bootstrap"
 :upstream_url "https://www.haskell.org/ghc/"
 :source {:url "http://downloads.haskell.org/~ghc/8.2.1/ghc-8.2.1-x86_64-deb8-linux.tar.xz"
          :sha256 :543b81bf610240bd0398111d6c6607a9094dc2d159b564057d46c8a3d1aaa130
          :dirname :ghc-8.2.1}
 :deps [:karate/gcc
        :karate/glibc
        :karate/gmp
        :karate/libffi
        :karate/ncurses5
        :karate/perl]
 :build_deps [:karate/make :karate/patchelf]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:lib/ghc-8.2.1/include]
 :interpreters [:bin/runhaskell :bin/runghc]
 :build (fn [b]
          (b:log "Fixing interpreter for binaries:")
          ;; Each ELF executable under the source, its interpreter glibc's.
          (each [_ f (ipairs (b:find b.src "*"))]
            (when (and (not (b:exists (b:join f ".")))
                       (: (b:capture [:file :-i f]) :find
                          "x-executable; charset=binary" 1 true))
              (b:log f)
              (b:run [:patchelf
                      :--interpreter
                      (.. (b:path_for :karate/glibc) :/lib/ld-linux-x86-64.so.2)
                      f])))
          (b:env :LD_LIBRARY_PATH
                 (.. (or (b:getenv :LD_LIBRARY_PATH) "") ":" (b:path_for :gmp)
                     "/lib:" (b:path_for :ncurses5) "/lib:" (b:path_for :libffi)
                     :/lib))
          (b:run [:./configure
                  (.. :--prefix= b.prefix)
                  (.. :--with-gmp-includes= (b:path_for :gmp) :/include)
                  (.. :--with-gmp-libraries= (b:path_for :gmp) :/lib)]))
 :install (fn [b]
            (var v-ghc-lib-paths "")
            (b.default.install b)
            ;; The directories under the prefix holding shared libraries, each once.
            (set v-ghc-lib-paths [])
            (let [seen {}]
              (each [_ f (ipairs (b:find b.prefix :*.so))]
                (let [dir (f:match "^(.*)/[^/]+$")]
                  (when (not (. seen dir))
                    (tset seen dir true)
                    (table.insert v-ghc-lib-paths dir)))))
            (b:log "Fixing rpath for binaries:")
            ;; Each ELF executable in the prefix finds glibc's libraries and, relative to
            ;; itself ($ORIGIN), the package's own.

            (fn relative [from to]
              (let [split (fn [p]
                            (icollect [part (p:gmatch "[^/]+")] part))
                    a (split from)
                    c (split to)]
                (var i 1)
                (while (and (<= i (length a)) (<= i (length c))
                            (= (. a i) (. c i)))
                  (set i (+ i 1)))
                (let [out []]
                  (for [_ i (length a)] (table.insert out ".."))
                  (for [j i (length c)] (table.insert out (. c j)))
                  (if (= (length out) 0) "." (table.concat out "/")))))

            (each [_ f (ipairs (b:find b.prefix "*"))]
              (when (and (not (b:exists (b:join f ".")))
                         (: (b:capture [:file :-i f]) :find
                            "x-executable; charset=binary" 1 true))
                (b:log f)
                (let [dir (f:match "^(.*)/[^/]+$")
                      origins (icollect [_ lib (ipairs v-ghc-lib-paths)]
                                (.. :$ORIGIN/ (relative dir lib)))]
                  (b:run [:patchelf
                          :--set-rpath
                          (.. (or (b:getenv :LD_RUN_PATH) "") ":"
                              (table.concat origins ":"))
                          f])))))
 :strip (fn [b]
          nil)}
