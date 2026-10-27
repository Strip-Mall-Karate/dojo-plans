;; netcat-openbsd, ported from its plan.sh.
;; The source project's plan downloaded Debian's patch series and each patch it
;; names, unverified, from sources.debian.net. These are Debian's 1.105-7 patches
;; as one archive from snapshot.debian.org, pinned; the source moved there too.
{:name :netcat-openbsd
 :origin :karate
 :version :1.105
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:BSD-3-Clause]
 :description "TCP/IP swiss army knife, OpenBSD variant"
 :upstream_url "https://tracker.debian.org/pkg/netcat"
 :source {:url "https://snapshot.debian.org/archive/debian/20190410T000000Z/pool/main/n/netcat-openbsd/netcat-openbsd_1.105.orig.tar.gz"
          :sha256 :40653fe66c1516876b61b07e093d826e2a5463c5d994f1b7e6ce328f3edb211e}
 :deps [:karate/glibc :karate/libbsd]
 :build_deps [:karate/gcc :karate/make :karate/patch :karate/pkg-config]
 :bin_dirs [:bin]
 :download (fn [b]
             (b.default.download b)
             (b:log "Downloading Debian's patches...")
             (b:download "https://snapshot.debian.org/archive/debian/20190410T000000Z/pool/main/n/netcat-openbsd/netcat-openbsd_1.105-7.debian.tar.gz"
                         :eee759327ffea293e81d0dde67921b7fcfcad279ffd7a2c9d037bbc8f882b363
                         :netcat-openbsd_1.105-7.debian.tar.gz))
 :prepare (fn [b]
            ;; Debian's patches, in the order its series file gives.
            (let [debian (b:join b.cache :netcat-openbsd-1.105-7-debian)]
              (b:remove debian)
              (b:mkdir debian)
              (b:run [:tar
                      :xf
                      (b:join b.cache :netcat-openbsd_1.105-7.debian.tar.gz)]
                     {:cwd debian})
              (each [patchfile (string.gmatch (b:read (b:join debian
                                                              :debian/patches/series))
                                              "[^\n]+")]
                (b:log (.. "Applying patch: " patchfile))
                (b:run [:patch
                        :-i
                        (b:join debian (.. :debian/patches/ patchfile))]))))
 :build (fn [b]
          (b:run [:make
                  (.. :CFLAGS= (or (b:getenv :CFLAGS) "") " -g -O2")
                  (.. :LDFLAGS= (or (b:getenv :LDFLAGS) "")
                      " -Wl,--no-add-needed,--as-needed")]))
 :install (fn [b]
            (b:mkdir (.. b.prefix :/bin))
            (b:copy (b:join b.src :nc) (.. b.prefix :/bin/nc))
            (b:chmod (.. b.prefix :/bin/nc) :755))}
