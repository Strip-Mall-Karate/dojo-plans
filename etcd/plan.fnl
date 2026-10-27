;; etcd, ported from its plan.sh.
{:name :etcd
 :origin :karate
 :version :v3.3.10
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0]
 :description "Distributed reliable key-value store for the most critical data of a distributed system"
 :upstream_url "https://github.com/coreos/etcd/"
 :source {:url "https://github.com/coreos/etcd/releases/download/v3.3.10/etcd-v3.3.10-linux-amd64.tar.gz"
          :sha256 :1620a59150ec0a0124a65540e23891243feb2d9a628092fb1edcc23974724a45
          :dirname :etcd-v3.3.10-linux-amd64}
 :deps [:karate/curl]
 :build_deps [:karate/gnupg]
 :bin_dirs [:usr/bin]
 :svc {:user :root}
 :exports {:client-port :etcd-client-end :server-port :etcd-server-end}
 :exposes [:client-port :server-port]
 :download (fn [b]
             (b.default.download b)
             (b:download (.. "https://github.com/coreos/" b.name
                             :/releases/download/ b.version "/" b.name "-"
                             b.version :-linux-amd64.tar.gz.asc)
                         :cc4bdd4f0a83efa46a34b590544ba7bb3ad494d07d43cf3f85933b660b97638a
                         (.. b.name "-" b.version :-linux-amd64.tar.gz.asc))
             (b:download "https://coreos.com/dist/pubkeys/app-signing-pubkey.gpg"
                         :16b93904e4b3133fe4b5f95f46e3db998c3b2f9d9cee6d4c2eb531f98028bcb3
                         :app-signing-pubkey.gpg))
 :verify (fn [b]
           (b.default.verify b)
           (b:log (.. "Verifying " b.name "-" b.version
                      "-linux-amd64.tar.gz signature"))
           (var v-gnupghome (b:capture [:mktemp :-d :-p b.cache]))
           (b:run [:gpg
                   :--import
                   :--keyid-format
                   :LONG
                   (.. b.cache :/app-signing-pubkey.gpg)])
           (b:run [:gpg
                   :--batch
                   :--verify
                   (.. b.cache "/" b.name "-" b.version
                       :-linux-amd64.tar.gz.asc)
                   (.. b.cache "/" b.name "-" b.version :-linux-amd64.tar.gz)])
           (b:remove v-gnupghome)
           (b:log (.. "Signature verified for " b.name "-" b.version
                      :-linux-amd64.tar.gz)))
 :build (fn [b]
          nil)
 :install (fn [b]
            (when (not (b:exists (.. b.prefix :/etc/nsswitch.conf)))
              (b:mkdir (.. b.prefix :/etc/))
              (b:run [:touch (.. b.prefix :/etc/nsswitch.conf)])
              (b:write (.. b.prefix :/etc/nsswitch.conf) "hosts: files dns\n"))
            (b:mkdir (.. b.prefix :/var/lib/etcd))
            (b:copy (.. b.cache :/etcd-v3.3.10-linux-amd64/etcd)
                    (.. b.prefix :/usr/bin/etcd))
            (b:chmod (.. b.prefix :/usr/bin/etcd) :755)
            (b:copy (.. b.cache :/etcd-v3.3.10-linux-amd64/etcdctl)
                    (.. b.prefix :/usr/bin/etcdctl))
            (b:chmod (.. b.prefix :/usr/bin/etcdctl) :755))
 :strip (fn [b]
          nil)}
