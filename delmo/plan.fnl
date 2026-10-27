;; delmo, ported from its plan.sh.
{:name :delmo
 :origin :karate
 :version :0.6.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0]
 :description "DelMo is a tool to test systems running within multiple docker containers."
 :upstream_url "https://github.com/bodymindarts/delmo"
 :source {:url "https://github.com/bodymindarts/delmo/releases/download/v0.6.1/delmo-linux-amd64"
          :sha256 :1d7a3a27f5c65a281315325bda9b87c176cd3b6f82b26e4eab290bbe2eefb221
          :filename :delmo}
 :bin_dirs [:bin]
 :unpack (fn [b]
           nil)
 :build (fn [b]
          nil)
 :install (fn [b]
            (if (b:exists (.. b.src "/" b.name))
                (b:move (.. b.cache "/" b.name)
                        (b:join (.. b.src "/" b.name)
                                (: (.. b.cache "/" b.name) :match "[^/]+$")))
                (b:move (.. b.cache "/" b.name) (.. b.src "/" b.name)))
            (b:copy b.name (.. b.prefix :/bin/ b.name))
            (b:chmod (.. b.prefix :/bin/ b.name) :755))}
