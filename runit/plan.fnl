;; runit, ported from its plan.sh.
{:name :runit
 :origin :karate
 :version :2.1.2
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:BSD]
 :source {:url "http://smarden.org/runit/runit-2.1.2.tar.gz"
          :sha256 :6fd0160cb0cf1207de4e66754b6d39750cff14bb0aa66ab49490992c0c47ba18}
 :deps [:karate/glibc]
 :build_deps [:karate/coreutils :karate/gcc :karate/make]
 :bin_dirs [:bin]
 :unpack (fn [b]
           (b:mkdir (.. b.cache "/" b.name "-" b.version))
           (b:run [:tar
                   :zxf
                   (.. b.cache :/runit-2.1.2.tar.gz)
                   :-C
                   (.. b.cache "/" b.name "-" b.version)]))
 :build (fn [b]
          (b:run [:./package/compile] {:cwd (.. :admin/runit- b.version)}))
 :install (fn [b]
            (b:mkdir (.. b.prefix :/bin))
            (each [_ p (ipairs (b:glob (b:join b.src
                                               (.. :admin/runit- b.version
                                                   :/command))
                                       "*"))]
              (b:copy p (b:join (.. b.prefix :/bin) (p:match "[^/]+$")))))}
