;; jetty, ported from its plan.sh.
;; jetty 12.1.14, the latest release on 2026-10-26: 9.1.5's source no longer downloads.
{:name :jetty
 :origin :karate
 :version :12.1.14
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0]
 :description "Jetty webserver and Java container"
 :upstream_url "https://eclipse.org/jetty"
 :source {:url "https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-home/12.1.14/jetty-home-12.1.14.tar.gz"
          :sha256 :f269b7b98691a48647e54ca5bce9d1042c0eb5f12a0887879974f418f70baa23}
 :deps [:karate/which :karate/coreutils :karate/bash :karate/jdk7]
 :unpack (fn [b]
           (var v-source-dir "")
           (var v-unpack-file "")
           (set v-source-dir (.. b.cache "/" b.name "-" b.version))
           (set v-unpack-file (.. b.cache :/jetty-home-12.1.14.tar.gz))
           (b:mkdir v-source-dir)
           (b:run [:tar :xz :--strip-components=1 :-f v-unpack-file]
                  {:cwd v-source-dir}))
 :build (fn [_b]
          nil)
 :install (fn [b]
            (b:mkdir (.. b.prefix :/jetty))
            (each [_ p (ipairs (b:glob b.src "*"))]
              (b:copy p (b:join (.. b.prefix :/jetty) (p:match "[^/]+$"))))
            (b:run [:find
                    (.. b.prefix :/jetty)
                    :-type
                    :d
                    :-exec
                    :chmod
                    :-v
                    :755
                    "{}"
                    "+"])
            (b:run [:find
                    (.. b.prefix :/jetty)
                    :-type
                    :f
                    :-exec
                    :chmod
                    :-v
                    :644
                    "{}"
                    "+"])
            (b:run [:find
                    (.. b.prefix :/jetty)
                    :-type
                    :f
                    :-name
                    :*.sh
                    :-exec
                    :chmod
                    :-v
                    :755
                    "{}"
                    "+"])
            (b:fix_interpreter [(.. b.prefix :/jetty/bin/jetty.sh)]
                               :karate/coreutils :bin/env))}
