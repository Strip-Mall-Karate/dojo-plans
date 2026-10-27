;; ipvsadm, ported from its plan.sh.
{:name :ipvsadm
 :origin :karate
 :version :1.29
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-3.0-or-later]
 :description "Ipvsadm is used to set up, maintain or inspect the virtual server table in the Linux kernel."
 :upstream_url "http://www.linuxvirtualserver.org/software/ipvs.html"
 :source {:url "https://mirrors.edge.kernel.org/pub/linux/utils/kernel/ipvsadm/ipvsadm-1.29.tar.xz"
          :sha256 :c3de4a21d90a02c621f0c72ee36a7aa27374b6f29fd4178f33fbf71b4c66c149}
 :deps [:karate/glibc :karate/popt :karate/libnl :karate/bash :karate/grep]
 :build_deps [:karate/busybox-static
              :karate/make
              :karate/gcc
              :karate/pkg-config
              :karate/patch]
 :bin_dirs [:bin]
 :build (fn [b]
          (b:run [:patch :-p1 :-i (.. b.plan_dir :/Makefile.patch)])
          (b:run [:make]))
 :install (fn [b]
            (b:copy (b:join b.src :ipvsadm)
                    (b:join (.. b.prefix :/bin)
                            (: (b:join b.src :ipvsadm) :match "[^/]+$")))
            (b:chmod (b:join (.. b.prefix :/bin)
                             (: (b:join b.src :ipvsadm) :match "[^/]+$"))
                     :0755)
            (b:copy (b:join b.src :ipvsadm-save)
                    (b:join (.. b.prefix :/bin)
                            (: (b:join b.src :ipvsadm-save) :match "[^/]+$")))
            (b:chmod (b:join (.. b.prefix :/bin)
                             (: (b:join b.src :ipvsadm-save) :match "[^/]+$"))
                     :0755)
            (b:copy (b:join b.src :ipvsadm-restore)
                    (b:join (.. b.prefix :/bin)
                            (: (b:join b.src :ipvsadm-restore) :match "[^/]+$")))
            (b:chmod (b:join (.. b.prefix :/bin)
                             (: (b:join b.src :ipvsadm-restore) :match "[^/]+$"))
                     :0755)
            (b:fix_interpreter [(.. b.prefix :/bin/ipvsadm-save)] :karate/bash
                               :bin/bash)
            (b:fix_interpreter [(.. b.prefix :/bin/ipvsadm-restore)]
                               :karate/bash :bin/bash)
            (let [text (b:read (.. b.prefix :/bin/ipvsadm-save))
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
                  (when (string.find line :^PATH)
                    (set line (pick-values 1 (string.gsub line "^" "#" 1)))))
                (when (not deleted) (table.insert out line))
                (each [_ x (ipairs after)] (table.insert out x)))
              (b:write (.. b.prefix :/bin/ipvsadm-save)
                       (.. (table.concat out "\n")
                           (if (and ends (> (length out) 0))
                               "\n"
                               ""))))
            (let [text (b:read (.. b.prefix :/bin/ipvsadm-restore))
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
                  (when (string.find line :^PATH)
                    (set line (pick-values 1 (string.gsub line "^" "#" 1)))))
                (when (not deleted) (table.insert out line))
                (each [_ x (ipairs after)] (table.insert out x)))
              (b:write (.. b.prefix :/bin/ipvsadm-restore)
                       (.. (table.concat out "\n")
                           (if (and ends (> (length out) 0))
                               "\n"
                               "")))))}
