;; busybox, ported from its plan.sh.
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
                                                             (: :/doj/svc/busybox/var
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

{:name :busybox
 :origin :karate
 :version :1.29.2
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:gplv2]
 :description "BusyBox is the Swiss Army Knife of embedded Linux. BusyBox combines tiny versions of many common UNIX utilities into a single small executable. It provides replacements for most of the utilities you usually find in GNU fileutils, shellutils, etc."
 :upstream_url "https://www.busybox.net/"
 :source {:url "http://www.busybox.net/downloads/busybox-1.29.2.tar.bz2"
          :sha256 :67d2fa6e147a45875fe972de62d907ef866fe784c495c363bf34756c444a5d61}
 :deps [:karate/glibc]
 :build_deps [:karate/bash
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
            (v--create-config b))
 :build (fn [b]
          (b:run [:make (.. :-j (tostring b.jobs))]))
 :install (fn [b]
            (b:copy (b:join b.src :busybox) (.. b.prefix :/bin/busybox))
            (b:chmod (.. b.prefix :/bin/busybox) :755)
            (b:run [(.. b.prefix :/bin/busybox)])
            (each [l (string.gmatch (b:capture [:busybox :--list]) "%S+")]
              (b:symlink :busybox (.. b.prefix :/bin/ l))))}
