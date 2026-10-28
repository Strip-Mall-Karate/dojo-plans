;; mongo-tools, ported from its plan.sh.
{:name :mongo-tools
 :origin :karate
 :version :3.5.13
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "MongoDB Tools"
 :upstream_url "https://github.com/mongodb/mongo-tools"
 :source {:url "https://github.com/mongodb/mongo-tools/archive/r3.5.13.tar.gz"
          :sha256 :c842c8e19fc04492817149403b04ad484241351b7b46d46d9f6355019c72c2de
          :filename :mongo-tools-3.5.13.tar.gz
          :dirname :mongo-tools-r3.5.13}
 :deps [:karate/glibc]
 :build_deps [:karate/go :karate/coreutils :karate/gcc :karate/make]
 :bin_dirs [:bin]
 :build (fn [b]
          (b:run [:./set_gopath.sh])
          (b:env :GOPATH (.. :/doj/cache/src/mongo-tools-r b.version
                             "/.gopath:/doj/cache/src/mongo-tools-r" b.version
                             :/vendor))
          (each [_ v-i (ipairs [:mongodump
                                :mongoexport
                                :mongofiles
                                :mongoimport
                                :mongooplog
                                :mongorestore
                                :mongostat
                                :mongotop])]
            (b:run [:go :build :-o (.. :bin/ v-i) (.. v-i :/main/ v-i :.go)])))
 :install (fn [b]
            (b:mkdir (.. b.prefix :/bin))
            (each [_ p (ipairs (b:glob (b:join b.src :bin) "*"))]
              (b:copy p (b:join (.. b.prefix :/bin) (p:match "[^/]+$")))))}
