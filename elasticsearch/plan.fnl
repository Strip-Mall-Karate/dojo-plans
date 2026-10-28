;; elasticsearch, ported from its plan.sh.
{:name :elasticsearch
 :origin :karate
 :version :6.7.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license ["Revised BSD"]
 :description "Open Source, Distributed, RESTful Search Engine"
 :upstream_url "https://elastic.co"
 :source {:url "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.7.1.tar.gz"
          :sha256 :7be3f94882130c769e5a6b95dbccdc3cab9f101cbc68edfa661f7188c78f06e2}
 :deps [:karate/coreutils-static
        :karate/busybox-static
        :karate/glibc
        :karate/zlib
        :karate/corretto8
        :karate/wget]
 :build_deps [:karate/patchelf]
 :bin_dirs [:es/bin]
 :lib_dirs [:es/lib]
 :exports {:http-port :network.port :transport-port :transport.port}
 :exposes [:http-port :transport-port]
 :binds_optional {:elasticsearch [:http-port :transport-port]}
 :build (fn [_b]
          nil)
 :install (fn [b]
            (var v--es-ml-bins "")
            (b:copy (b:join b.src :README.textile)
                    (.. b.prefix :/README.textile))
            (b:chmod (.. b.prefix :/README.textile) :644)
            (b:copy (b:join b.src :LICENSE.txt) (.. b.prefix :/LICENSE.txt))
            (b:chmod (.. b.prefix :/LICENSE.txt) :644)
            (b:copy (b:join b.src :NOTICE.txt) (.. b.prefix :/NOTICE.txt))
            (b:chmod (.. b.prefix :/NOTICE.txt) :644)
            (b:mkdir (.. b.prefix :/es))
            (each [_ p (ipairs (b:glob b.src "*"))]
              (b:copy p (b:join (.. b.prefix :/es) (p:match "[^/]+$"))))
            (each [_ p (ipairs (b:glob (.. b.prefix :/es/bin) :*.bat))]
              (b:remove p))
            (each [_ p (ipairs (b:glob (.. b.prefix :/es/bin) :*.exe))]
              (b:remove p))
            (b:env :LD_RUN_PATH
                   (.. (or (b:getenv :LD_RUN_PATH) "") ":" b.prefix
                       :/es/modules/x-pack-ml/platform/linux-x86_64/lib))
            (set v--es-ml-bins [:autoconfig
                                :autodetect
                                :categorize
                                :controller
                                :normalize])
            (each [_ v-bin (ipairs v--es-ml-bins)]
              (b:log (.. "patch " b.prefix
                         :/es/modules/x-pack-ml/platform/linux-x86_64/bin/ v-bin))
              (b:run [:patchelf
                      :--interpreter
                      (.. (b:path_for :glibc) :/lib/ld-linux-x86-64.so.2)
                      :--set-rpath
                      (or (b:getenv :LD_RUN_PATH) "")
                      (.. b.prefix
                          :/es/modules/x-pack-ml/platform/linux-x86_64/bin/
                          v-bin)])
              (b:run [:find
                      (.. b.prefix
                          :/es/modules/x-pack-ml/platform/linux-x86_64/lib)
                      :-type
                      :f
                      :-name
                      :*.so
                      :-exec
                      :patchelf
                      :--set-rpath
                      (or (b:getenv :LD_RUN_PATH) "")
                      "{}"
                      ";"])))
 :strip (fn [_b]
          nil)}
