;; libmaxminddb, ported from its plan.sh.
(fn use-dependency-path [b path replacement]
  ;; The source project's studio linked a dependency's tool to `path` for the
  ;; build. A Dojo build writes nothing outside itself, so the build's scripts
  ;; name the dependency's tool instead.
  (each [_ f (ipairs (b:find b.src "*"))]
    (let [name (: f :match "[^/]+$")]
      (when (and (or (: name :match :^configure) (: name :match :^Makefile)
                     (: name :match :^ltmain) (: name :match "%.in$")
                     (: name :match "%.am$") (: name :match "%.ac$")
                     (: name :match "%.m4$") (: name :match "%.mk$")
                     (: name :match "%.sh$") (: name :match "%.pl$")
                     (: name :match "%.py$"))
                 (not (b:exists (b:join f "."))))
        (let [text (b:read f)
              escaped (pick-values 1
                                   (: path :gsub "[%^%$%(%)%%%.%[%]%*%+%-%?]"
                                      "%%%0"))
              (fixed n) (: text :gsub escaped
                           (pick-values 1 (: replacement :gsub "%%" "%%%%")))]
          (when (> n 0) (b:write f fixed)))))))

{:name :libmaxminddb
 :origin :karate
 :version :1.3.2
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0]
 :description "C library for the MaxMind DB file format"
 :upstream_url "https://github.com/maxmind/libmaxminddb"
 :source {:url "https://github.com/maxmind/libmaxminddb/releases/download/1.3.2/libmaxminddb-1.3.2.tar.gz"
          :sha256 :e6f881aa6bd8cfa154a44d965450620df1f714c6dc9dd9971ad98f6e04f6c0f0}
 :deps [:karate/gcc-libs :karate/glibc]
 :build_deps [:karate/coreutils
              :karate/diffutils
              :karate/file
              :karate/gcc
              :karate/make
              :karate/perl]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :prepare (fn [b]
            (var v-interpreter-new "")
            (var v-interpreter-old "")
            (use-dependency-path b :/usr/bin/file (b:path_for :file :bin/file))
            (set v-interpreter-old :/usr/bin/env)
            (set v-interpreter-new (.. (b:path_for :coreutils) :/bin/env))
            (each [v-filetofix (: (b:capture [:grep
                                              :-nrlI
                                              "\\#\\!/usr/bin/env"
                                              (.. b.cache "/"
                                                  (.. b.name "-" b.version) :/t)])
                                  :gmatch "[^\n          ]+")]
              (b:log (.. "Setting interpreter for " v-filetofix " to "
                         v-interpreter-new))
              (let [text (b:read (if (= (: v-filetofix :sub 1 1) "/")
                                     v-filetofix
                                     (b:join b.src v-filetofix)))
                    ends (= (text:sub -1) "\n")
                    lines []
                    out []]
                (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")]
                  (table.insert lines l))
                (each [n l (ipairs lines)]
                  (var line l)
                  (var deleted false)
                  (local after [])
                  (when (not deleted)
                    (set line
                         (pick-values 1
                                      (string.gsub line
                                                   (.. "#!"
                                                       (pick-values 1
                                                                    (: v-interpreter-old
                                                                       :gsub
                                                                       "[%^%$%(%)%%%.%[%]%*%+%-%?]"
                                                                       "%%%0")))
                                                   (.. "#!"
                                                       (pick-values 1
                                                                    (: v-interpreter-new
                                                                       :gsub
                                                                       "%%"
                                                                       "%%%%")))
                                                   1))))
                  (when (not deleted) (table.insert out line))
                  (each [_ x (ipairs after)] (table.insert out x)))
                (b:write (if (= (: v-filetofix :sub 1 1) "/") v-filetofix
                             (b:join b.src v-filetofix))
                         (.. (table.concat out "\n")
                             (if (and ends (> (length out) 0))
                                 "\n"
                                 ""))))))
 :check (fn [b]
          (b:run [:make :check]))
 :install (fn [b]
            (var v-geoip-install-path "")
            (b.default.install b)
            (set v-geoip-install-path (.. b.prefix :/share/GeoIP))
            (b:mkdir v-geoip-install-path)
            (b:log "Installing GeoIP City Files")
            (b:download "https://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz"
                        :589b8603a6cd98cf134f96de24618ba1d986a954e40409a67f398eb1edbf6084
                        (.. v-geoip-install-path :/GeoLite2-City.tar.gz))
            (b:run [:tar :-xf :GeoLite2-City.tar.gz]
                   {:cwd v-geoip-install-path})
            (b:remove (b:join v-geoip-install-path :GeoLite2-City.tar.gz))
            (b:log "Installing GeoIP Country Files")
            (b:mkdir v-geoip-install-path)
            (b:download "https://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.tar.gz"
                        :1b627bd7a575500cbf9e675630ab2c9b1632c3727f3eab29a06e50568341bdfa
                        (.. v-geoip-install-path :/GeoLite2-Country.tar.gz))
            (b:run [:tar :-xf :GeoLite2-Country.tar.gz]
                   {:cwd v-geoip-install-path})
            (b:remove (b:join v-geoip-install-path :GeoLite2-Country.tar.gz))
            (b:log "Installing GeoIP ASN Files")
            (b:mkdir v-geoip-install-path)
            (b:download "https://geolite.maxmind.com/download/geoip/database/GeoLite2-ASN.tar.gz"
                        :6fc0855cdc3514c5b7cf19fe1a2681c5b1bbc5009c3a89b1453b64c8c235ba2a
                        (.. v-geoip-install-path :/GeoLite2-ASN.tar.gz))
            (b:run [:tar :-xf :GeoLite2-ASN.tar.gz] {:cwd v-geoip-install-path})
            (b:remove (b:join v-geoip-install-path :GeoLite2-ASN.tar.gz)))
 :strip (fn [b]
          (b.default.strip b)
          ;; From do_end.
          )}
