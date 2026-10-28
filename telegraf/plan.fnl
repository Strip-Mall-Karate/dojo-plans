;; telegraf, ported from its plan.sh.
{:name :telegraf
 :origin :karate
 :version :1.10.2
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "telegraf - client for InfluxDB"
 :upstream_url "https://github.com/influxdata/telegraf/"
 :source {:url "https://dl.influxdata.com/telegraf/releases/telegraf-1.10.2-static_linux_amd64.tar.gz"
          :sha256 :e97c17f79a9f4562b8379ec8d51e4e9085a71889306b49200aaf9903554eb63e}
 :build_deps [:karate/wget :karate/tar]
 :bin_dirs [:bin]
 :svc {:run "telegraf --config /doj/svc/telegraf/config/telegraf.conf"}
 :build (fn [_b]
          nil)
 :install (fn [b]
            (b:copy (.. b.cache :/telegraf/telegraf)
                    (.. b.prefix :/bin/telegraf))
            (b:chmod (.. b.prefix :/bin/telegraf) :755))}
