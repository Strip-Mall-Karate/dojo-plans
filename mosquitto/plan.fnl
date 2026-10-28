;; mosquitto, ported from its plan.sh.
{:name :mosquitto
 :origin :karate
 :version :1.4.15
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:EPL-1.0 "Eclipse Distribution License - v 1.0"]
 :description "An Open Source MQTT v3.1/v3.1.1 Broker"
 :upstream_url "https://mosquitto.org"
 :source {:url "http://mosquitto.org/files/source/mosquitto-1.4.15.tar.gz"
          :sha256 :7d3b3e245a3b4ec94b05678c8199c806359737949f4cfe0bf936184f6ca89a83}
 :deps [:karate/bash
        :karate/c-ares
        :karate/gcc-libs
        :karate/glibc
        :karate/openssl
        :karate/util-linux]
 :build_deps [:karate/gcc :karate/make]
 :bin_dirs [:bin :sbin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :svc {:run "mosquitto -c /doj/svc/mosquitto/config/mosquitto.conf"}
 :prepare (fn [b]
            (let [text (b:read (b:join b.src :config.mk))
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
                                    (string.gsub line :prefix=/usr/local
                                                 :prefix= 1))))
                (when (not deleted) (table.insert out line))
                (each [_ x (ipairs after)] (table.insert out x)))
              (b:write (b:join b.src :config.mk)
                       (.. (table.concat out "\n")
                           (if (and ends (> (length out) 0))
                               "\n"
                               ""))))
            (b:env :DESTDIR b.prefix))
 :build (fn [b]
          (b:run [:make]))
 :install (fn [b]
            (var v-sources "")
            (b.default.install b)
            (set v-sources (.. b.cache "/" b.name "-" b.version))
            (b:copy (.. v-sources :/edl-v10)
                    (b:join b.prefix
                            (: (.. v-sources :/edl-v10) :match "[^/]+$")))
            (b:copy (.. v-sources :/epl-v10)
                    (b:join b.prefix
                            (: (.. v-sources :/epl-v10) :match "[^/]+$"))))}
