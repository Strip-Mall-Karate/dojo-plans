;; eudev, ported from its plan.sh.
{:name :eudev
 :origin :karate
 :version :3.2.7
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-2.0]
 :description "eudev is a device manager for the Linux kernel"
 :upstream_url "https://wiki.gentoo.org/wiki/Project:Eudev"
 :source {:url "http://dev.gentoo.org/~blueness/eudev/eudev-3.2.7.tar.gz"
          :sha256 :3004614bd253c1f98558460215027aaf60d7592c70be27fd384ec01db87bf062}
 :deps [:karate/glibc :karate/gperf]
 :build_deps [:karate/make :karate/gcc :karate/sed]
 :bin_dirs [:bin :sbin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]
 :prepare (fn [b]
            (let [text (b:read (b:join b.src :test/udev-test.pl))
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
                                    (string.gsub line "/usr(/bin/test)" "%1" 1))))
                (when (not deleted) (table.insert out line))
                (each [_ x (ipairs after)] (table.insert out x)))
              (b:write (b:join b.src :test/udev-test.pl)
                       (.. (table.concat out "\n")
                           (if (and ends (> (length out) 0))
                               "\n"
                               ""))))
            (let [text (b:read (b:join b.src :src/udev/udev-builtin-keyboard.c))
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
                  (when (string.find line :keyboard_lookup_key)
                    (set deleted true)))
                (when (not deleted) (table.insert out line))
                (each [_ x (ipairs after)] (table.insert out x)))
              (b:write (b:join b.src :src/udev/udev-builtin-keyboard.c)
                       (.. (table.concat out "\n")
                           (if (and ends (> (length out) 0))
                               "\n"
                               ""))))
            (b:write (b:join b.src :config.cache) "HAVE_BLKID=1
BLKID_LIBS=\"-lblkid\"
BLKID_CFLAGS=\"-I/tools/include\"
"))}
