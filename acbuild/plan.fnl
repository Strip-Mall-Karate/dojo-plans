;; acbuild, ported from its plan.sh.
{:name :acbuild
 :origin :karate
 :version :0.4.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2]
 :description "A tool to build Application Container Images (ACI)"
 :upstream_url "https://github.com/containers/build"
 :source {:url "https://github.com/containers/build/archive/v0.4.0.tar.gz"
          :sha256 :88d99a002eb53212752d6f405d9e02555512b27c5b84e8ef5828607ee9774ed4
          :dirname :build-0.4.0}
 :deps [:karate/gnupg :karate/glibc]
 :build_deps [:karate/go :karate/coreutils]
 :bin_dirs [:bin]
 :prepare (fn [b]
            (b.default.prepare b)
            (b:log "Modifying 'build' file")
            (let [text (b:read (b:join b.src :build))
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
                                    (string.gsub line "#!/usr/bin/env"
                                                 (.. "#!"
                                                     (pick-values 1
                                                                  (: (b:path_for :karate/coreutils)
                                                                     :gsub "%%"
                                                                     "%%%%"))
                                                     :/bin/env)
                                                 1))))
                (when (not deleted) (table.insert out line))
                (each [_ x (ipairs after)] (table.insert out x)))
              (b:write (b:join b.src :build)
                       (.. (table.concat out "\n")
                           (if (and ends (> (length out) 0))
                               "\n"
                               ""))))
            (let [text (b:read (b:join b.src :build))
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
                                    (string.gsub line
                                                 "VERSION=$%(cd \"${DIR}\" && git describe %-%-dirty%)"
                                                 (.. :VERSION=
                                                     (pick-values 1
                                                                  (b.version:gsub "%%"
                                                                                  "%%%%")))
                                                 1))))
                (when (not deleted) (table.insert out line))
                (each [_ x (ipairs after)] (table.insert out x)))
              (b:write (b:join b.src :build)
                       (.. (table.concat out "\n")
                           (if (and ends (> (length out) 0))
                               "\n"
                               "")))))
 :build (fn [b]
          (b:run [:./build]))
 :install (fn [b]
            (b:copy (.. b.cache :/build-0.4.0/bin/acbuild)
                    (b:join (.. b.prefix :/bin/)
                            (: (.. b.cache :/build-0.4.0/bin/acbuild) :match
                               "[^/]+$"))))}
