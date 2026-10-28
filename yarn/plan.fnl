;; yarn, ported from its plan.sh.
{:name :yarn
 :origin :karate
 :version :1.12.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:BSD-2-Clause]
 :description "Yarn is a package manager for your code. It allows you to use and share code with other developers from around the world. Yarn does this quickly, securely, and reliably so you don’t ever have to worry."
 :upstream_url "https://yarnpkg.com/"
 :source {:url "https://yarnpkg.com/downloads/1.12.1/yarn-v1.12.1.tar.gz"
          :sha256 :09bea8f4ec41e9079fa03093d3b2db7ac5c5331852236d63815f8df42b3ba88d}
 :deps [:karate/coreutils :karate/node :karate/sed]
 :bin_dirs [:bin]
 :unpack (fn [b]
           (b:mkdir (.. b.name "-" b.version))
           (b:run [:tar
                   :--strip-components=1
                   (.. :--directory= b.name "-" b.version)
                   :-xf
                   :yarn-v1.12.1.tar.gz] {:cwd b.cache}))
 :build (fn [_b]
          nil)
 :install (fn [b]
            (each [v-f (: (b:capture [:find :bin :-type :f]) :gmatch
                          "[^\n          ]+")]
              (b:copy (if (= (v-f:sub 1 1) "/") v-f (b:join b.src v-f))
                      (.. b.prefix "/" v-f))
              (b:chmod (.. b.prefix "/" v-f) :0755))
            (each [_ p (ipairs (b:glob (.. b.prefix :/bin) :*.cmd))]
              (b:remove p))
            (each [v-f (: (b:capture [:find
                                      :lib
                                      :LICENSE
                                      :package.json
                                      :-type
                                      :f]) :gmatch
                          "[^\n          ]+")]
              (b:copy (if (= (v-f:sub 1 1) "/") v-f (b:join b.src v-f))
                      (.. b.prefix "/" v-f))
              (b:chmod (.. b.prefix "/" v-f) :0644)))}
