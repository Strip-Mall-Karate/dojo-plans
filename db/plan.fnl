;; db, ported from its plan.sh.
;; db 5.3.28, the latest release on 2026-10-26 under the Sleepycat license: 6.0 and later are AGPL.
{:name :db
 :origin :karate
 :version :5.3.28
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:custom]
 :description "Berkeley DB is a family of embedded key-value database libraries providing scalable high-performance data management services to applications."
 :upstream_url "http://www.oracle.com/technetwork/database/database-technologies/berkeleydb/overview/index.html"
 :source {:url "https://download.oracle.com/berkeley-db/db-5.3.28.tar.gz"
          :sha256 :e0a992d740709892e81f9d93f06daf305cf73fb81b545afe72478043172c3628}
 :deps [:karate/glibc :karate/gcc-libs]
 :build_deps [:karate/coreutils
              :karate/diffutils
              :karate/patch
              :karate/make
              :karate/gcc]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :prepare (fn [b]
            (b:run [:patch :-p0 :-i (.. b.plan_dir :/patches/atomic.patch)]))
 :build (fn [b]
          ;; Berkeley DB 5.3's configure probes use implicit int and declarations, which gcc 14
          ;; and later reject unless -fpermissive; with them failing it falls back to FCNTL
          ;; mutexes, which it refuses.
          (b:env :CFLAGS
                 (.. (or (b:getenv :CFLAGS) "") " -std=gnu17 -fpermissive"))
          (b:run [:../dist/configure
                  (.. :--prefix= b.prefix)
                  :--enable-compat185
                  :--enable-cxx
                  :--enable-dbm
                  :--enable-stl] {:cwd :build_unix})
          (b:run [:make :LIBSO_LIBS=-lpthread (.. :-j (tostring b.jobs))]
                 {:cwd :build_unix}))
 :install (fn [b]
            (b:run [:make :install] {:cwd :build_unix})
            (b:run [:make :uninstall_docs] {:cwd :build_unix})
            (b:copy (b:join b.src :LICENSE)
                    (.. b.prefix :/share/licenses/LICENSE))
            (b:chmod (.. b.prefix :/share/licenses/LICENSE) :644))}
