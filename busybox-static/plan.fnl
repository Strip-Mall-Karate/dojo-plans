;; busybox-static, ported from its plan.sh.
;; busybox-static 1.38.0, the latest release on 2026-10-26.
;; Built from the busybox plan, with its own changes.
(fn v--create-config [b]
  (b:log "Customizing busybox configuration...")
  (b:write (b:join b.src :.config)
           (let [text (b:read (.. b.plan_dir :/config))
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
                                   (string.gsub line "@pkg_prefix@"
                                                (pick-values 1
                                                             (b.prefix:gsub "%%"
                                                                            "%%%%"))))))
               (when (not deleted)
                 (set line
                      (pick-values 1
                                   (string.gsub line "@pkg_svc_var@"
                                                (pick-values 1
                                                             (: :/doj/svc/busybox-static/var
                                                                :gsub "%%"
                                                                "%%%%"))))))
               (when (not deleted)
                 (set line
                      (pick-values 1
                                   (string.gsub line "@cflags@"
                                                (pick-values 1
                                                             (: (or (b:getenv :CFLAGS)
                                                                    "")
                                                                :gsub "%%"
                                                                "%%%%"))))))
               (when (not deleted)
                 (set line
                      (pick-values 1
                                   (string.gsub line "@ldflags@"
                                                (pick-values 1
                                                             (: (or (b:getenv :LDFLAGS)
                                                                    "")
                                                                :gsub "%%"
                                                                "%%%%"))))))
               (when (not deleted)
                 (set line (pick-values 1 (string.gsub line "@osname@" :Dojo))))
               (when (not deleted)
                 (set line
                      (pick-values 1 (string.gsub line "@bash_is_ash@" :y))))
               (when (not deleted) (table.insert out line))
               (each [_ x (ipairs after)] (table.insert out x)))
             (.. (table.concat out "\n")
                 (if (and ends (> (length out) 0))
                     "\n"
                     "")))))

{:name :busybox-static
 :origin :karate
 :version :1.38.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:gplv2]
 :description "BusyBox is the Swiss Army Knife of embedded Linux. BusyBox combines tiny versions of many common UNIX utilities into a single small executable. It provides replacements for most of the utilities you usually find in GNU fileutils, shellutils, etc."
 :upstream_url "https://www.busybox.net/"
 :source {:url "https://busybox.net/downloads/busybox-1.38.0.tar.bz2"
          :sha256 :34f9ea6ff8636f2c9241153b9114eefa9e65674a45318ae1ef95bb5f31c53bb2
          :dirname :busybox-1.38.0}
 :build_deps [:karate/linux-headers-musl
              :karate/musl
              :karate/bash
              :karate/bison
              :karate/coreutils
              :karate/diffutils
              :karate/findutils
              :karate/flex
              :karate/gawk
              :karate/gcc
              :karate/gettext
              :karate/grep
              :karate/gzip
              :karate/libtool
              :karate/make
              :karate/patch
              :karate/sed
              :karate/texinfo
              :karate/util-linux
              :karate/wget
              :karate/xz]
 :bin_dirs [:bin]
 :interpreters [:bin/ash :bin/awk :bin/env :bin/sh :bin/bash]
 :prepare (fn [b]
            (b:env :CFLAGS
                   (.. :-I (b:path_for :linux-headers-musl) "/include -I"
                       (b:path_for :musl) :/include))
            (b:log (.. "Overriding CFLAGS=" (or (b:getenv :CFLAGS) "")))
            (b:env :LDFLAGS :-g)
            (b:log (.. "Overriding LDFLAGS=" (or (b:getenv :LDFLAGS) "")))
            ;; The plan read busybox's config from beside it; a build reads only its own
            ;; plan's directory, which holds a copy.
            (v--create-config b)
            (let [text (b:read (b:join b.src :.config))
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
                  (when (string.find line :CONFIG_STATIC)
                    (set line
                         (pick-values 1
                                      (string.gsub line "^.*$" :CONFIG_STATIC=y
                                                   1)))))
                (when (not deleted)
                  (when (string.find line :CONFIG_FEATURE_UTMP)
                    (set line
                         (pick-values 1
                                      (string.gsub line "^.*$"
                                                   :CONFIG_FEATURE_UTMP=n 1)))))
                (when (not deleted)
                  (when (string.find line :CONFIG_FEATURE_WTMP)
                    (set line
                         (pick-values 1
                                      (string.gsub line "^.*$"
                                                   :CONFIG_FEATURE_WTMP=n 1)))))
                (when (not deleted)
                  (when (string.find line :CONFIG_INETD)
                    (set line
                         (pick-values 1
                                      (string.gsub line "^.*$" :CONFIG_INETD=n
                                                   1)))))
                ;; Traffic control needs the CBQ definitions kernel headers dropped in 6.8.
                (when (not deleted)
                  (when (string.find line :^CONFIG_TC=) (set line :CONFIG_TC=n)))
                (when (not deleted) (table.insert out line))
                (each [_ x (ipairs after)] (table.insert out x)))
              (b:write (b:join b.src :.config)
                       (.. (table.concat out "\n")
                           (if (and ends (> (length out) 0))
                               "\n"
                               ""))))
            (let [text (b:read (b:join b.src :include/libbb.h))
                  ends (= (text:sub -1) "\n")
                  lines []
                  out []]
              (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")]
                (table.insert lines l))
              (each [n l (ipairs lines)]
                (local line l)
                (local deleted false)
                (local after [])
                (when (not deleted)
                  (when (and (>= n 1) (<= n 1))
                    (table.insert out "#include <sys/resource.h>")))
                (when (not deleted) (table.insert out line))
                (each [_ x (ipairs after)] (table.insert out x)))
              (b:write (b:join b.src :include/libbb.h)
                       (.. (table.concat out "\n")
                           (if (and ends (> (length out) 0))
                               "\n"
                               "")))))
 :build (fn [b]
          ;; The config predates options busybox added since; oldconfig gives each its default.
          (b:run [:make :oldconfig :CC=musl-gcc]
                 {:stdin (string.rep "\n" 4000)})
          (b:run [:make (.. :-j (tostring b.jobs)) :CC=musl-gcc]))
 :install (fn [b]
            (b:copy (b:join b.src :busybox) (.. b.prefix :/bin/busybox))
            (b:chmod (.. b.prefix :/bin/busybox) :755)
            (b:run [(.. b.prefix :/bin/busybox)])
            (each [l (string.gmatch (b:capture [:busybox :--list]) "%S+")]
              (b:symlink :busybox (.. b.prefix :/bin/ l))))}
