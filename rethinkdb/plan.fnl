;; rethinkdb, ported from its plan.sh.
;; rethinkdb 2.4.4, the latest release on 2026-10-26: 2.3.6's source no longer downloads.
(fn use-dependency-path [b path replacement]
  ;; The source project's studio linked a dependency's tool to `path` for the
  ;; build. A Dojo build writes nothing outside itself, so the build's scripts
  ;; name the dependency's tool instead.
  (each [_ f (ipairs (b:find b.src "*"))]
    (let [name (f:match "[^/]+$")]
      (when (and (or (name:match :^configure) (name:match :^Makefile)
                     (name:match :^ltmain) (name:match "%.in$")
                     (name:match "%.am$") (name:match "%.ac$")
                     (name:match "%.m4$") (name:match "%.mk$")
                     (name:match "%.sh$") (name:match "%.pl$")
                     (name:match "%.py$"))
                 (not (b:exists (b:join f "."))))
        (let [text (b:read f)
              escaped (pick-values 1
                                   (path:gsub "[%^%$%(%)%%%.%[%]%*%+%-%?]"
                                              "%%%0"))
              (fixed n) (text:gsub escaped
                                   (pick-values 1
                                                (replacement:gsub "%%" "%%%%")))]
          (when (> n 0) (b:write f fixed)))))))

{:name :rethinkdb
 :origin :karate
 :version :2.4.4
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0]
 :description "The open-source database for the realtime web."
 :upstream_url "https://rethinkdb.com"
 :source {:url "https://download.rethinkdb.com/repository/raw/dist/rethinkdb-2.4.4.tgz"
          :sha256 :5091237602b62830db2cb3daaca6ab34632323741e6710c2f0de4d84f442711f}
 :deps [:karate/openssl/1.0.2l
        :karate/gcc-libs/5.2.0
        :karate/protobuf/2.6.1/20170514031228
        :karate/zlib/1.2.8
        :karate/curl/7.54.1/20180329185356
        :karate/ncurses/6.0]
 :build_deps [:karate/gcc/5.2.0
              :karate/make
              :karate/python2
              :karate/boost
              :karate/coreutils
              :karate/jemalloc
              :karate/m4
              :karate/patch]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :exports {:http-port :http-port
           :driver-port :driver-port
           :cluster-port :cluster-port}
 :exposes [:http-port :driver-port :cluster-port]
 :binds_optional {:rethinkdb [:cluster-port]}
 :prepare (fn [b]
            (use-dependency-path b :/usr/bin/env
                                 (b:path_for :coreutils :bin/env)))
 :build (fn [b]
          (b:env :ALLOW_WARNINGS :1)
          (b:run [:./configure (.. :--prefix= b.prefix) :--allow-fetch])
          (b:run [:make (.. :-j (tostring b.jobs))]))
 :strip (fn [b]
          (b.default.strip b)
          ;; From do_end.
          )}
