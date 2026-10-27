;; docker17, ported from its plan.sh.
{:name :docker17
 :origin :karate
 :version :17.12.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2]
 :description "The Docker Engine"
 :upstream_url "https://docs.docker.com/engine/installation/binaries/"
 :source {:url "https://download.docker.com/linux/static/stable/x86_64/docker-17.12.1-ce.tgz"
          :sha256 :1270dce1bd7e1838d62ae21d2505d87f16efc1d9074645571daaefdfd0c14054
          :dirname :docker}
 :bin_dirs [:bin]
 :build (fn [b]
          nil)
 :install (fn [b]
            (each [_ p (ipairs (b:glob b.src :docker*))]
              (let [v-bin (: p :match "[^/]+$")]
                (b:copy (if (= (: v-bin :sub 1 1) "/") v-bin
                            (b:join b.src v-bin))
                        (.. b.prefix :/bin/ v-bin))
                (b:chmod (.. b.prefix :/bin/ v-bin) :755))))
 :strip (fn [b]
          nil)}
