;; leiningen, ported from its plan.sh.
{:name :leiningen
 :origin :karate
 :version :2.8.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:EPL-1.0]
 :description "Automate Clojure projects without setting your hair on fire."
 :upstream_url "https://leiningen.org/"
 :source {:url "https://github.com/technomancy/leiningen/releases/download/2.8.1/leiningen-2.8.1-standalone.zip"
          :sha256 :fc49bbc7ff25ef42ad9c0a8b5f3d0641702abc9a9a8e847bc845bca4c09a7c58
          :filename :leiningen-2.8.1-standalone.zip}
 :deps [:karate/bash :karate/coreutils :karate/corretto8]
 :bin_dirs [:bin]
 :download (fn [b]
             (b.default.download b)
             ;; Checked against the SHA-256 the plan's do_verify gave it.
             (b:download (.. "https://raw.github.com/technomancy/" b.name "/"
                             b.version :/bin/lein-pkg)
                         :9108095b5f377bdfb630a5c65bd963ea288b11ab08e868473cbd7763eaa96472
                         :lein))
 :verify (fn [b]
           (b.default.verify b))
 :unpack (fn [b]
           (if (b:exists (.. b.cache :/leiningen-2.8.1-standalone.jar))
               (b:move (.. b.cache :/leiningen-2.8.1-standalone.zip)
                       (b:join (.. b.cache :/leiningen-2.8.1-standalone.jar)
                               (: (.. b.cache :/leiningen-2.8.1-standalone.zip)
                                  :match "[^/]+$")))
               (b:move (.. b.cache :/leiningen-2.8.1-standalone.zip)
                       (.. b.cache :/leiningen-2.8.1-standalone.jar))))
 :build (fn [b]
          (b:fix_interpreter [(.. b.cache :/lein)] :karate/bash :bin/bash))
 :install (fn [b]
            (b:mkdir (.. b.prefix :/share/java))
            (let [text (b:read (b:join b.cache :lein))
                  ends (= (text:sub -1) "\n")
                  lines []
                  out []]
              (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")]
                (table.insert lines l))
              (each [_n l (ipairs lines)]
                (var line l)
                (local deleted false)
                (local after [])
                (when (not deleted)
                  (set line
                       (pick-values 1
                                    (string.gsub line :^LEIN_JAR=.*
                                                 (.. :LEIN_JAR=
                                                     (pick-values 1
                                                                  (b.prefix:gsub "%%"
                                                                                 "%%%%"))
                                                     :/share/java/
                                                     (pick-values 1
                                                                  (: :leiningen-2.8.1-standalone
                                                                     :gsub "%%"
                                                                     "%%%%"))
                                                     :.jar)
                                                 1))))
                (when (not deleted) (table.insert out line))
                (each [_ x (ipairs after)] (table.insert out x)))
              (b:write (b:join b.cache :lein)
                       (.. (table.concat out "\n")
                           (if (and ends (> (length out) 0))
                               "\n"
                               ""))))
            (b:chmod (b:join b.cache :lein) :+x)
            (b:copy (b:join b.cache :lein) (.. b.prefix :/bin/lein))
            (b:chmod (.. b.prefix :/bin/lein) :755)
            (b:copy (b:join b.cache :leiningen-2.8.1-standalone.jar)
                    (.. b.prefix :/share/java/leiningen-2.8.1-standalone.jar))
            (b:chmod (.. b.prefix :/share/java/leiningen-2.8.1-standalone.jar)
                     :755))}
