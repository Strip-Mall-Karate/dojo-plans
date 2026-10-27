;; leveldb, ported from its plan.sh.
{:name :leveldb
 :origin :karate
 :version :1.20
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:BSD-3-Clause]
 :description "LevelDB is a fast key-value storage library written at Google that provides an ordered mapping from string keys to string values."
 :upstream_url "https://github.com/google/leveldb"
 :source {:url "https://github.com/google/leveldb/archive/v1.20.tar.gz"
          :sha256 :f5abe8b5b209c2f36560b75f32ce61412f39a2922f7045ae764a2c23335b6664}
 :deps [:karate/snappy :karate/glibc :karate/gcc-libs]
 :build_deps [:karate/make :karate/gcc]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :build (fn [b]
          (b:run [:make]))
 :install (fn [b]
            (each [_ p (ipairs (b:glob (b:join b.src :out-shared) :libleveldb.*))]
              (b:copy p (b:join (.. b.prefix :/lib) (: p :match "[^/]+$"))))
            (if (b:exists (.. b.prefix :/include))
                (b:copy (b:join b.src :include/leveldb)
                        (b:join (.. b.prefix :/include)
                                (: (b:join b.src :include/leveldb) :match
                                   "[^/]+$")))
                (b:copy (b:join b.src :include/leveldb) (.. b.prefix :/include))))}
