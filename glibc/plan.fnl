;; glibc, ported from its plan.sh.
;; glibc 2.44, the latest release on 2026-10-26.
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

(fn v-extract-src [b a1]
  (var v-build-dirname "")
  (var v-plan "")
  (set v-build-dirname (.. (.. b.name "-" b.version) "/../" b.name :-build))
  (set v-plan a1)
  ;; The plan sourced the named plan to download and unpack its source into the
  ;; build directory. glibc names only tzdata; these are its source and unpacking.
  (when (not= v-plan :tzdata)
    (error (.. "extract_src: no source known for " v-plan)))
  (let [url "https://www.iana.org/time-zones/repository/releases/tzdata2018g.tar.gz"
        dir (.. b.cache "/" b.name :-build/tzdata)]
    (b:log (.. "Downloading " url))
    (b:download url
                :02dfde534872f6513ae4553a3388fdae579441e31b862ea99170dfc447f46a16
                :tzdata2018g.tar.gz)
    (b:remove dir)
    (b:mkdir dir)
    (b:run [:tar :xf (.. b.cache :/tzdata2018g.tar.gz)] {:cwd dir})))

{:name :glibc
 :origin :karate
 :version :2.44
 :targets [:x86_64-linux :x86_64-linux-kernel2]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-2.0 :LGPL-2.0]
 :description "The GNU C Library project provides the core libraries for the GNU system and GNU/Linux systems, as well as many other systems that use Linux as the kernel. These libraries provide critical APIs including ISO C11, POSIX.1-2008, BSD, OS-specific APIs and more. These APIs include such foundational facilities as open, read, write, malloc, printf, getaddrinfo, dlopen, pthread_create, crypt, login, exit and more."
 :upstream_url "https://www.gnu.org/software/libc"
 :source {:url "https://ftp.gnu.org/gnu/glibc/glibc-2.44.tar.xz"
          :sha256 :37f600f2bef3c5e8300147059568b2a2e40a7ad6ccc65ce942556d49429cc667}
 :deps [:karate/linux-headers]
 :build_deps [:karate/coreutils
              :karate/bison
              :karate/diffutils
              :karate/patch
              :karate/make
              :karate/gcc
              :karate/sed
              :karate/perl
              :karate/python]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :prepare (fn [b]
            (var v-dynamic-linker "")
            ;; The plan linked coreutils' pwd to /bin/pwd (/tools' in the source project's
            ;; stage1 studio, which Dojo does not have).
            (use-dependency-path b :/bin/pwd
                                 (b:path_for :karate/coreutils :bin/pwd))
            (set v-dynamic-linker (.. b.prefix :/lib/ld-linux-x86-64.so.2))
            (b:unsetenv :LD_RUN_PATH)
            (b:log (.. "Overriding LD_RUN_PATH="
                       (or (b:getenv :LD_RUN_PATH) "")))
            (b:unsetenv :CFLAGS)
            (b:log (.. "Overriding CFLAGS=" (or (b:getenv :CFLAGS) "")))
            (b:env :LDFLAGS (.. "-Wl,--dynamic-linker=" v-dynamic-linker))
            (b:log (.. "Setting LDFLAGS=" (or (b:getenv :LDFLAGS) "")))
            (b:write (b:join b.src :nscd/Makefile) (.. (if (b:exists (b:join b.src
                                                                             :nscd/Makefile))
                                                           (b:read (b:join b.src
                                                                           :nscd/Makefile))
                                                           "")
                                                       "LDFLAGS-nscd += -static-libgcc
"))
            (b:run [:patch :-p1]
                   {:stdin (let [text (b:read (.. b.plan_dir
                                                  :/dont-use-system-ld-so.patch))
                                 ends (= (text:sub -1) "\n")
                                 lines []
                                 out []]
                             (each [l (string.gmatch (if ends text
                                                         (.. text "\n"))
                                                     "(.-)\n")]
                               (table.insert lines l))
                             (each [n l (ipairs lines)]
                               (var line l)
                               (var deleted false)
                               (local after [])
                               (when (not deleted)
                                 (set line
                                      (pick-values 1
                                                   (string.gsub line "@prefix@"
                                                                (pick-values 1
                                                                             (: b.prefix
                                                                                :gsub
                                                                                "%%"
                                                                                "%%%%"))))))
                               (when (not deleted) (table.insert out line))
                               (each [_ x (ipairs after)] (table.insert out x)))
                             (.. (table.concat out "\n")
                                 (if (and ends (> (length out) 0))
                                     "\n"
                                     "")))})
            (let [text (b:read (b:join b.src :scripts/test-installation.pl))
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
                                    (string.gsub line "libs %-o"
                                                 (.. "libs -L"
                                                     (pick-values 1
                                                                  (: b.prefix
                                                                     :gsub "%%"
                                                                     "%%%%"))
                                                     "/lib -Wl,-dynamic-linker="
                                                     (pick-values 1
                                                                  (: v-dynamic-linker
                                                                     :gsub "%%"
                                                                     "%%%%"))
                                                     " -o")
                                                 1))))
                (when (not deleted) (table.insert out line))
                (each [_ x (ipairs after)] (table.insert out x)))
              (b:write (b:join b.src :scripts/test-installation.pl)
                       (.. (table.concat out "\n")
                           (if (and ends (> (length out) 0))
                               "\n"
                               "")))))
 :build (fn [b]
          (b:remove (b:join b.src (.. "../" b.name :-build)))
          (b:mkdir (b:join b.src (.. "../" b.name :-build)))
          (b:write (b:join (b:join b.src (.. "../" b.name :-build))
                           :config.cache)
                   (.. (if (b:exists (b:join (b:join b.src
                                                     (.. "../" b.name :-build))
                                             :config.cache))
                           (b:read (b:join (b:join b.src
                                                   (.. "../" b.name :-build))
                                           :config.cache))
                           "")
                       (.. (.. :libc_cv_slibdir= b.prefix :/lib) "\n")))
          (b:write (b:join (b:join b.src (.. "../" b.name :-build))
                           :config.cache) (.. (if (b:exists (b:join (b:join b.src
                                                                                               (.. "../"
                                                                                                   b.name
                                                                                                   :-build))
                                                                                       :config.cache))
                                                                     (b:read (b:join (b:join b.src
                                                                                             (.. "../"
                                                                                                 b.name
                                                                                                 :-build))
                                                                                     :config.cache))
                                                                     "")
                                                                 "libc_cv_ssp=no
"))
          (b:run [(.. "../" (.. b.name "-" b.version) :/configure)
                  (.. :--prefix= b.prefix)
                  (.. :--sbindir= b.prefix :/bin)
                  (.. :--with-headers= (b:path_for :linux-headers) :/include)
                  (.. :--libdir= b.prefix :/lib)
                  (.. :--libexecdir= b.prefix :/lib/glibc)
                  (.. :--sysconfdir= b.prefix :/etc)
                  :--enable-obsolete-rpc
                  :--disable-profile
                  :--enable-kernel=2.6.32
                  :--cache-file=config.cache]
                 {:cwd (.. "../" b.name :-build)})
          (b:run [:make] {:cwd (.. "../" b.name :-build)}))
 :check (fn [b]
          ;; The plan linked the cat on PATH, coreutils', to /bin/cat.
          (use-dependency-path b :/bin/cat
                               (b:path_for :karate/coreutils :bin/cat))
          ;; The plan linked coreutils' echo to /bin/echo (/tools' in the source project's
          ;; stage1 studio, which Dojo does not have).
          (use-dependency-path b :/bin/echo
                               (b:path_for :karate/coreutils :bin/echo))
          (if (= (or (b:getenv :STUDIO_TYPE) "") :stage1)
              (do
                (b:symlink :/tools/lib/libgcc_s.so.1
                           (b:join (b:join b.src (.. "../" b.name :-build))
                                   :libgcc_s.so.1))
                (b:symlink :/tools/lib/libstdc++.so.6
                           (b:join (b:join b.src (.. "../" b.name :-build))
                                   :libstdc++.so.6)))
              (do
                (b:symlink (.. (b:path_for :gcc) :/lib/libgcc_s.so.1)
                           (b:join (b:join b.src (.. "../" b.name :-build))
                                   (: (.. (b:path_for :gcc) :/lib/libgcc_s.so.1)
                                      :match "[^/]+$")))
                (b:symlink (.. (b:path_for :gcc) :/lib/libstdc++.so.6)
                           (b:join (b:join b.src (.. "../" b.name :-build))
                                   (: (.. (b:path_for :gcc)
                                          :/lib/libstdc++.so.6)
                                      :match "[^/]+$")))))
          (b:run [:make :check] {:cwd (.. "../" b.name :-build) :check false})
          (b:remove (b:join (b:join b.src (.. "../" b.name :-build))
                            :libgcc_s.so.1))
          (b:remove (b:join (b:join b.src (.. "../" b.name :-build))
                            :libstdc++.so.6)))
 :install (fn [b]
            (b:mkdir (.. b.prefix :/etc))
            (b:run [:touch (.. b.prefix :/etc/ld.so.conf)]
                   {:cwd (.. "../" b.name :-build)})
            (b:mkdir (.. b.prefix :/lib))
            (let [link (if (b:exists (b:join (.. b.prefix :/lib/ld-linux.so.2)
                                             "."))
                           (b:join (.. b.prefix :/lib/ld-linux.so.2)
                                   (: (.. :ld- b.version :.so) :match "[^/]+$"))
                           (.. b.prefix :/lib/ld-linux.so.2))]
              (b:symlink (.. :ld- b.version :.so) link))
            (let [link (if (b:exists (b:join (.. b.prefix :/lib64) "."))
                           (b:join (.. b.prefix :/lib64) :lib)
                           (.. b.prefix :/lib64))]
              (b:symlink :lib link))
            ;; In the source project's stage1 studio, which Dojo does not have, the plan copied
            ;; the bootstrap toolchain's libgcc_s into the package.
            (b:run [:make
                    :install
                    (.. :sysconfdir= b.prefix :/etc)
                    (.. :sbindir= b.prefix :/bin)]
                   {:cwd (.. "../" b.name :-build)})
            (each [_ p (ipairs (b:glob (.. b.prefix :/sbin) "*"))]
              (b:move p (b:join (.. b.prefix :/bin/) (: p :match "[^/]+$"))))
            (b:remove (.. b.prefix :/sbin))
            (b:remove (.. b.prefix :/lib/ld-linux.so.2))
            (b:remove (.. b.prefix :/bin/sln))
            (each [_ v-b (ipairs [:ldd :sotruss :tzselect :xtrace])]
              (let [text (b:read (.. b.prefix :/bin/ v-b))
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
                                      (string.gsub line "^#!.*$" "#! /bin/sh" 1))))
                  (when (not deleted) (table.insert out line))
                  (each [_ x (ipairs after)] (table.insert out x)))
                (b:write (.. b.prefix :/bin/ v-b)
                         (.. (table.concat out "\n")
                             (if (and ends (> (length out) 0))
                                 "\n"
                                 "")))))
            ;; Each of linux-headers' include entries but scsi/, which glibc provides, linked here.
            (each [_ entry (ipairs (b:glob (.. (b:path_for :karate/linux-headers)
                                               :/include)
                                           "*"))]
              (when (not= (entry:match "[^/]+$") :scsi)
                (b:symlink entry
                           (b:join (.. b.prefix :/include)
                                   (entry:match "[^/]+$")))))
            (b:mkdir (.. b.prefix :/lib/locale))
            (b:run [:localedef :-i :cs_CZ :-f :UTF-8 :cs_CZ.UTF-8]
                   {:cwd (.. "../" b.name :-build)})
            (b:run [:localedef :-i :de_DE :-f :ISO-8859-1 :de_DE]
                   {:cwd (.. "../" b.name :-build)})
            (b:run [:localedef :-i "de_DE@euro" :-f :ISO-8859-15 "de_DE@euro"]
                   {:cwd (.. "../" b.name :-build)})
            (b:run [:localedef :-i :en_HK :-f :ISO-8859-1 :en_HK]
                   {:cwd (.. "../" b.name :-build)})
            (b:run [:localedef :-i :en_PH :-f :ISO-8859-1 :en_PH]
                   {:cwd (.. "../" b.name :-build)})
            (b:run [:localedef :-i :en_US :-f :ISO-8859-1 :en_US]
                   {:cwd (.. "../" b.name :-build)})
            (b:run [:localedef :-i :en_US :-f :UTF-8 :en_US]
                   {:cwd (.. "../" b.name :-build)})
            (b:run [:localedef :-i :es_MX :-f :ISO-8859-1 :es_MX]
                   {:cwd (.. "../" b.name :-build)})
            (b:run [:localedef :-i :fa_IR :-f :UTF-8 :fa_IR]
                   {:cwd (.. "../" b.name :-build)})
            (b:run [:localedef :-i :fr_FR :-f :ISO-8859-1 :fr_FR]
                   {:cwd (.. "../" b.name :-build)})
            (b:run [:localedef :-i "fr_FR@euro" :-f :ISO-8859-15 "fr_FR@euro"]
                   {:cwd (.. "../" b.name :-build)})
            (b:run [:localedef :-i :it_IT :-f :ISO-8859-1 :it_IT]
                   {:cwd (.. "../" b.name :-build)})
            (b:run [:localedef :-i :ja_JP :-f :EUC-JP :ja_JP]
                   {:cwd (.. "../" b.name :-build)})
            (b:copy (b:join (b:join b.src (.. "../" b.name :-build))
                            (.. "../" (.. b.name "-" b.version)
                                :/nscd/nscd.conf))
                    (b:join (.. b.prefix :/etc/)
                            (: (b:join (b:join b.src (.. "../" b.name :-build))
                                       (.. "../" (.. b.name "-" b.version)
                                           :/nscd/nscd.conf))
                               :match "[^/]+$")))
            (b:write (.. b.prefix :/etc/nsswitch.conf) "passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files
")
            (v-extract-src b :tzdata)
            (var v-zoneinfo (.. b.prefix :/share/zoneinfo))
            (b:mkdir (.. v-zoneinfo :/posix))
            (b:mkdir (.. v-zoneinfo :/right))
            (each [_ v-tz (ipairs [:etcetera
                                   :southamerica
                                   :northamerica
                                   :europe
                                   :africa
                                   :antarctica
                                   :asia
                                   :australasia
                                   :backward
                                   :pacificnew
                                   :systemv])]
              (b:run [:zic
                      :-L
                      :/dev/null
                      :-d
                      v-zoneinfo
                      :-y
                      "sh yearistype.sh"
                      v-tz]
                     {:cwd (.. (.. "../" b.name :-build) :/./tzdata)})
              (b:run [:zic
                      :-L
                      :/dev/null
                      :-d
                      (.. v-zoneinfo :/posix)
                      :-y
                      "sh yearistype.sh"
                      v-tz]
                     {:cwd (.. (.. "../" b.name :-build) :/./tzdata)})
              (b:run [:zic
                      :-L
                      :leapseconds
                      :-d
                      (.. v-zoneinfo :/right)
                      :-y
                      "sh yearistype.sh"
                      v-tz]
                     {:cwd (.. (.. "../" b.name :-build) :/./tzdata)}))
            (b:copy (b:join (b:join b.src
                                    (.. (.. "../" b.name :-build) :/./tzdata))
                            :zone.tab)
                    (b:join v-zoneinfo
                            (: (b:join (b:join b.src
                                               (.. (.. "../" b.name :-build)
                                                   :/./tzdata))
                                       :zone.tab)
                               :match "[^/]+$")))
            (b:copy (b:join (b:join b.src
                                    (.. (.. "../" b.name :-build) :/./tzdata))
                            :zone1970.tab)
                    (b:join v-zoneinfo
                            (: (b:join (b:join b.src
                                               (.. (.. "../" b.name :-build)
                                                   :/./tzdata))
                                       :zone1970.tab)
                               :match "[^/]+$")))
            (b:copy (b:join (b:join b.src
                                    (.. (.. "../" b.name :-build) :/./tzdata))
                            :iso3166.tab)
                    (b:join v-zoneinfo
                            (: (b:join (b:join b.src
                                               (.. (.. "../" b.name :-build)
                                                   :/./tzdata))
                                       :iso3166.tab)
                               :match "[^/]+$")))
            (b:run [:zic :-d v-zoneinfo :-p :America/New_York]
                   {:cwd (.. (.. "../" b.name :-build) :/./tzdata)})
            (set v-zoneinfo "")
            (if (b:exists (.. b.prefix :/etc/localtime))
                (b:copy (.. b.prefix :/share/zoneinfo/UTC)
                        (b:join (.. b.prefix :/etc/localtime)
                                (: (.. b.prefix :/share/zoneinfo/UTC) :match
                                   "[^/]+$")))
                (b:copy (.. b.prefix :/share/zoneinfo/UTC)
                        (.. b.prefix :/etc/localtime))))
 :strip (fn [b]
          (b.default.strip b)
          ;; From do_end.
          )
 :on {:x86_64-linux-kernel2 {:version :2.23
                             :license [:GPL-2.0 :LGPL-2.0]
                             :description "The GNU C Library project provides the core libraries for the GNU system and GNU/Linux systems,
as well as many other systems that use Linux as the kernel. These libraries provide critical
APIs including ISO C11, POSIX.1-2008, BSD, OS-specific APIs and more. These APIs include such
foundational facilities as open, read, write, malloc, printf, getaddrinfo, dlopen,
pthread_create, crypt, login, exit and more."
                             :upstream_url "https://www.gnu.org/software/libc"
                             :source {:url "http://ftp.gnu.org/gnu/glibc/glibc-2.23.tar.xz"
                                      :sha256 :94efeb00e4603c8546209cefb3e1a50a5315c86fa9b078b6fad758e187ce13e9}
                             :deps [:karate/linux-headers]
                             :build_deps [:karate/coreutils
                                          :karate/diffutils
                                          :karate/patch
                                          :karate/make
                                          :karate/gcc
                                          :karate/sed
                                          :karate/perl]
                             :bin_dirs [:bin]
                             :lib_dirs [:lib]
                             :include_dirs [:include]
                             :prepare (fn [b]
                                        (var v-dynamic-linker "")
                                        (use-dependency-path b :/bin/pwd
                                                             (b:path_for :coreutils
                                                                         :bin/pwd))
                                        (set v-dynamic-linker
                                             (.. b.prefix
                                                 :/lib/ld-linux-x86-64.so.2))
                                        (b:unsetenv :LD_RUN_PATH)
                                        (b:log (.. "Overriding LD_RUN_PATH="
                                                   (or (b:getenv :LD_RUN_PATH)
                                                       "")))
                                        (b:unsetenv :CFLAGS)
                                        (b:log (.. "Overriding CFLAGS="
                                                   (or (b:getenv :CFLAGS) "")))
                                        (b:env :LDFLAGS
                                               (.. "-Wl,--dynamic-linker="
                                                   v-dynamic-linker))
                                        (b:log (.. "Setting LDFLAGS="
                                                   (or (b:getenv :LDFLAGS) "")))
                                        (b:write (b:join b.src :nscd/Makefile)
                                                 (.. (if (b:exists (b:join b.src
                                                                           :nscd/Makefile))
                                                         (b:read (b:join b.src
                                                                         :nscd/Makefile))
                                                         "")
                                                     "LDFLAGS-nscd += -static-libgcc
"))
                                        (b:run [:patch
                                                :-p1
                                                :-i
                                                (.. (.. b.plan_dir
                                                        :/x86_64-linux-kernel2)
                                                    :/rpcgen-path.patch)])
                                        (b:run [:patch :-p1]
                                               {:stdin (let [text (b:read (.. (.. b.plan_dir
                                                                                  :/x86_64-linux-kernel2)
                                                                              :/dont-use-system-ld-so.patch))
                                                             ends (= (text:sub -1)
                                                                     "\n")
                                                             lines []
                                                             out []]
                                                         (each [l (string.gmatch (if ends
                                                                                     text
                                                                                     (.. text
                                                                                         "\n"))
                                                                                 "(.-)
")]
                                                           (table.insert lines
                                                                         l))
                                                         (each [n l (ipairs lines)]
                                                           (var line l)
                                                           (var deleted false)
                                                           (local after [])
                                                           (when (not deleted)
                                                             (set line
                                                                  (pick-values 1
                                                                               (string.gsub line
                                                                                            "@prefix@"
                                                                                            (pick-values 1
                                                                                                         (: b.prefix
                                                                                                            :gsub
                                                                                                            "%%"
                                                                                                            "%%%%"))))))
                                                           (when (not deleted)
                                                             (table.insert out
                                                                           line))
                                                           (each [_ x (ipairs after)]
                                                             (table.insert out
                                                                           x)))
                                                         (.. (table.concat out
                                                                           "\n")
                                                             (if (and ends
                                                                      (> (length out)
                                                                         0))
                                                                 "\n"
                                                                 "")))})
                                        (b:run [:patch
                                                :-p1
                                                :-i
                                                (.. (.. b.plan_dir
                                                        :/x86_64-linux-kernel2)
                                                    :/testsuite-fix.patch)])
                                        (b:run [:patch
                                                :-p1
                                                :-i
                                                (.. (.. b.plan_dir
                                                        :/x86_64-linux-kernel2)
                                                    :/glibc-2.23-upstream_fixes-1.patch)])
                                        (b:run [:patch
                                                :-p1
                                                :-i
                                                (.. (.. b.plan_dir
                                                        :/x86_64-linux-kernel2)
                                                    :/0005-fix-binutils-2-29-build.patch)])
                                        (b:run [:patch
                                                :-p1
                                                :-i
                                                (.. (.. b.plan_dir
                                                        :/x86_64-linux-kernel2)
                                                    :/gcc-implicit-boolean.patch)])
                                        (b:run [:patch
                                                :-p1
                                                :-i
                                                (.. (.. b.plan_dir
                                                        :/x86_64-linux-kernel2)
                                                    :/remove-sun-rpm-bug.patch)])
                                        (b:run [:patch
                                                :-p1
                                                :-i
                                                (.. (.. b.plan_dir
                                                        :/x86_64-linux-kernel2)
                                                    :/nss-nisplus-gcc7.patch)])
                                        (let [text (b:read (b:join b.src
                                                                   :scripts/test-installation.pl))
                                              ends (= (text:sub -1) "\n")
                                              lines []
                                              out []]
                                          (each [l (string.gmatch (if ends text
                                                                      (.. text
                                                                          "\n"))
                                                                  "(.-)\n")]
                                            (table.insert lines l))
                                          (each [n l (ipairs lines)]
                                            (var line l)
                                            (var deleted false)
                                            (local after [])
                                            (when (not deleted)
                                              (set line
                                                   (pick-values 1
                                                                (string.gsub line
                                                                             "libs %-o"
                                                                             (.. "libs -L"
                                                                                 (pick-values 1
                                                                                              (: b.prefix
                                                                                                 :gsub
                                                                                                 "%%"
                                                                                                 "%%%%"))
                                                                                 "/lib -Wl,-dynamic-linker="
                                                                                 (pick-values 1
                                                                                              (: v-dynamic-linker
                                                                                                 :gsub
                                                                                                 "%%"
                                                                                                 "%%%%"))
                                                                                 " -o")
                                                                             1))))
                                            (when (not deleted)
                                              (table.insert out line))
                                            (each [_ x (ipairs after)]
                                              (table.insert out x)))
                                          (b:write (b:join b.src
                                                           :scripts/test-installation.pl)
                                                   (.. (table.concat out "\n")
                                                       (if (and ends
                                                                (> (length out)
                                                                   0))
                                                           "\n"
                                                           "")))))
                             :build (fn [b]
                                      (b:remove (b:join b.src
                                                        (.. "../" b.name
                                                            :-build)))
                                      (b:mkdir (b:join b.src
                                                       (.. "../" b.name :-build)))
                                      (b:write (b:join (b:join b.src
                                                               (.. "../" b.name
                                                                   :-build))
                                                       :config.cache)
                                               (.. (if (b:exists (b:join (b:join b.src
                                                                                 (.. "../"
                                                                                     b.name
                                                                                     :-build))
                                                                         :config.cache))
                                                       (b:read (b:join (b:join b.src
                                                                               (.. "../"
                                                                                   b.name
                                                                                   :-build))
                                                                       :config.cache))
                                                       "")
                                                   (.. (.. :libc_cv_slibdir=
                                                           b.prefix :/lib)
                                                       "\n")))
                                      (b:write (b:join (b:join b.src
                                                               (.. "../" b.name
                                                                   :-build))
                                                       :config.cache)
                                               (.. (if (b:exists (b:join (b:join b.src
                                                                                 (.. "../"
                                                                                     b.name
                                                                                     :-build))
                                                                         :config.cache))
                                                       (b:read (b:join (b:join b.src
                                                                               (.. "../"
                                                                                   b.name
                                                                                   :-build))
                                                                       :config.cache))
                                                       "")
                                                   "libc_cv_ssp=no\n"))
                                      (b:run [(.. "../"
                                                  (.. b.name "-" b.version)
                                                  :/configure)
                                              (.. :--prefix= b.prefix)
                                              (.. :--sbindir= b.prefix :/bin)
                                              (.. :--with-headers=
                                                  (b:path_for :linux-headers)
                                                  :/include)
                                              (.. :--libdir= b.prefix :/lib)
                                              (.. :--libexecdir= b.prefix
                                                  :/lib/glibc)
                                              (.. :--sysconfdir= b.prefix :/etc)
                                              :--enable-obsolete-rpc
                                              :--disable-profile
                                              :--enable-kernel=2.6.32
                                              :--cache-file=config.cache]
                                             {:cwd (.. "../" b.name :-build)})
                                      (b:run [:make]
                                             {:cwd (.. "../" b.name :-build)}))
                             :check (fn [b]
                                      (use-dependency-path b :/bin/cat
                                                           (b:path_for :coreutils
                                                                       :bin/cat))
                                      (use-dependency-path b :/bin/echo
                                                           (b:path_for :coreutils
                                                                       :bin/echo))
                                      (if (= (or (b:getenv :STUDIO_TYPE) "")
                                             :stage1)
                                          (do
                                            (b:symlink :/tools/lib/libgcc_s.so.1
                                                       (b:join (b:join b.src
                                                                       (.. "../"
                                                                           b.name
                                                                           :-build))
                                                               :libgcc_s.so.1))
                                            (b:symlink :/tools/lib/libstdc++.so.6
                                                       (b:join (b:join b.src
                                                                       (.. "../"
                                                                           b.name
                                                                           :-build))
                                                               :libstdc++.so.6)))
                                          (do
                                            (b:symlink (.. (b:path_for :gcc)
                                                           :/lib/libgcc_s.so.1)
                                                       (b:join (b:join b.src
                                                                       (.. "../"
                                                                           b.name
                                                                           :-build))
                                                               (: (.. (b:path_for :gcc)
                                                                      :/lib/libgcc_s.so.1)
                                                                  :match
                                                                  "[^/]+$")))
                                            (b:symlink (.. (b:path_for :gcc)
                                                           :/lib/libstdc++.so.6)
                                                       (b:join (b:join b.src
                                                                       (.. "../"
                                                                           b.name
                                                                           :-build))
                                                               (: (.. (b:path_for :gcc)
                                                                      :/lib/libstdc++.so.6)
                                                                  :match
                                                                  "[^/]+$")))))
                                      (b:run [:make :check]
                                             {:cwd (.. "../" b.name :-build)
                                              :check false})
                                      (b:remove (b:join (b:join b.src
                                                                (.. "../"
                                                                    b.name
                                                                    :-build))
                                                        :libgcc_s.so.1))
                                      (b:remove (b:join (b:join b.src
                                                                (.. "../"
                                                                    b.name
                                                                    :-build))
                                                        :libstdc++.so.6)))
                             :install (fn [b]
                                        (b:mkdir (.. b.prefix :/etc))
                                        (b:run [:touch
                                                (.. b.prefix :/etc/ld.so.conf)]
                                               {:cwd (.. "../" b.name :-build)})
                                        (b:mkdir (.. b.prefix :/lib))
                                        (let [link (if (b:exists (b:join (.. b.prefix
                                                                             :/lib/ld-linux.so.2)
                                                                         "."))
                                                       (b:join (.. b.prefix
                                                                   :/lib/ld-linux.so.2)
                                                               :ld-2.23.so)
                                                       (.. b.prefix
                                                           :/lib/ld-linux.so.2))]
                                          (b:symlink :ld-2.23.so link))
                                        (let [link (if (b:exists (b:join (.. b.prefix
                                                                             :/lib64)
                                                                         "."))
                                                       (b:join (.. b.prefix
                                                                   :/lib64)
                                                               :lib)
                                                       (.. b.prefix :/lib64))]
                                          (b:symlink :lib link))
                                        ;; In the source project's stage1 studio, which Dojo does not have, the plan copied
                                        ;; the bootstrap toolchain's libgcc_s into the package.
                                        (b:run [:make
                                                :install
                                                (.. :sysconfdir= b.prefix :/etc)
                                                (.. :sbindir= b.prefix :/bin)]
                                               {:cwd (.. "../" b.name :-build)})
                                        (each [_ p (ipairs (b:glob (.. b.prefix
                                                                       :/sbin)
                                                                   "*"))]
                                          (b:move p
                                                  (b:join (.. b.prefix :/bin/)
                                                          (: p :match "[^/]+$"))))
                                        (b:remove (.. b.prefix :/sbin))
                                        (each [_ p (ipairs (b:glob (.. b.prefix
                                                                       :/include/rpcsvc)
                                                                   :*.x))]
                                          (b:remove p))
                                        (b:remove (.. b.prefix
                                                      :/lib/ld-linux.so.2))
                                        (b:remove (.. b.prefix :/bin/sln))
                                        (each [_ v-b (ipairs [:ldd
                                                              :sotruss
                                                              :tzselect
                                                              :xtrace])]
                                          (let [text (b:read (.. b.prefix
                                                                 :/bin/ v-b))
                                                ends (= (text:sub -1) "\n")
                                                lines []
                                                out []]
                                            (each [l (string.gmatch (if ends
                                                                        text
                                                                        (.. text
                                                                            "\n"))
                                                                    "(.-)\n")]
                                              (table.insert lines l))
                                            (each [n l (ipairs lines)]
                                              (var line l)
                                              (var deleted false)
                                              (local after [])
                                              (when (not deleted)
                                                (set line
                                                     (pick-values 1
                                                                  (string.gsub line
                                                                               "^#!.*$"
                                                                               "#! /bin/sh"
                                                                               1))))
                                              (when (not deleted)
                                                (table.insert out line))
                                              (each [_ x (ipairs after)]
                                                (table.insert out x)))
                                            (b:write (.. b.prefix :/bin/ v-b)
                                                     (.. (table.concat out "\n")
                                                         (if (and ends
                                                                  (> (length out)
                                                                     0))
                                                             "\n"
                                                             "")))))
                                        ;; Each of linux-headers' include entries but scsi/, which glibc provides, linked here.
                                        (each [_ entry (ipairs (b:glob (.. (b:path_for :karate/linux-headers)
                                                                           :/include)
                                                                       "*"))]
                                          (when (not= (entry:match "[^/]+$")
                                                      :scsi)
                                            (b:symlink entry
                                                       (b:join (.. b.prefix
                                                                   :/include)
                                                               (entry:match "[^/]+$")))))
                                        (b:mkdir (.. b.prefix :/lib/locale))
                                        (b:run [:localedef
                                                :-i
                                                :cs_CZ
                                                :-f
                                                :UTF-8
                                                :cs_CZ.UTF-8]
                                               {:cwd (.. "../" b.name :-build)})
                                        (b:run [:localedef
                                                :-i
                                                :de_DE
                                                :-f
                                                :ISO-8859-1
                                                :de_DE]
                                               {:cwd (.. "../" b.name :-build)})
                                        (b:run [:localedef
                                                :-i
                                                "de_DE@euro"
                                                :-f
                                                :ISO-8859-15
                                                "de_DE@euro"]
                                               {:cwd (.. "../" b.name :-build)})
                                        (b:run [:localedef
                                                :-i
                                                :en_HK
                                                :-f
                                                :ISO-8859-1
                                                :en_HK]
                                               {:cwd (.. "../" b.name :-build)})
                                        (b:run [:localedef
                                                :-i
                                                :en_PH
                                                :-f
                                                :ISO-8859-1
                                                :en_PH]
                                               {:cwd (.. "../" b.name :-build)})
                                        (b:run [:localedef
                                                :-i
                                                :en_US
                                                :-f
                                                :ISO-8859-1
                                                :en_US]
                                               {:cwd (.. "../" b.name :-build)})
                                        (b:run [:localedef
                                                :-i
                                                :en_US
                                                :-f
                                                :UTF-8
                                                :en_US]
                                               {:cwd (.. "../" b.name :-build)})
                                        (b:run [:localedef
                                                :-i
                                                :es_MX
                                                :-f
                                                :ISO-8859-1
                                                :es_MX]
                                               {:cwd (.. "../" b.name :-build)})
                                        (b:run [:localedef
                                                :-i
                                                :fa_IR
                                                :-f
                                                :UTF-8
                                                :fa_IR]
                                               {:cwd (.. "../" b.name :-build)})
                                        (b:run [:localedef
                                                :-i
                                                :fr_FR
                                                :-f
                                                :ISO-8859-1
                                                :fr_FR]
                                               {:cwd (.. "../" b.name :-build)})
                                        (b:run [:localedef
                                                :-i
                                                "fr_FR@euro"
                                                :-f
                                                :ISO-8859-15
                                                "fr_FR@euro"]
                                               {:cwd (.. "../" b.name :-build)})
                                        (b:run [:localedef
                                                :-i
                                                :it_IT
                                                :-f
                                                :ISO-8859-1
                                                :it_IT]
                                               {:cwd (.. "../" b.name :-build)})
                                        (b:run [:localedef
                                                :-i
                                                :ja_JP
                                                :-f
                                                :EUC-JP
                                                :ja_JP]
                                               {:cwd (.. "../" b.name :-build)})
                                        (b:copy (b:join (b:join b.src
                                                                (.. "../"
                                                                    b.name
                                                                    :-build))
                                                        (.. "../"
                                                            (.. b.name "-"
                                                                b.version)
                                                            :/nscd/nscd.conf))
                                                (b:join (.. b.prefix :/etc/)
                                                        (: (b:join (b:join b.src
                                                                           (.. "../"
                                                                               b.name
                                                                               :-build))
                                                                   (.. "../"
                                                                       (.. b.name
                                                                           "-"
                                                                           b.version)
                                                                       :/nscd/nscd.conf))
                                                           :match "[^/]+$")))
                                        (b:write (.. b.prefix
                                                     :/etc/nsswitch.conf)
                                                 "passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files
")
                                        (v-extract-src b :tzdata)
                                        (var v-zoneinfo
                                             (.. b.prefix :/share/zoneinfo))
                                        (b:mkdir (.. v-zoneinfo :/posix))
                                        (b:mkdir (.. v-zoneinfo :/right))
                                        (each [_ v-tz (ipairs [:etcetera
                                                               :southamerica
                                                               :northamerica
                                                               :europe
                                                               :africa
                                                               :antarctica
                                                               :asia
                                                               :australasia
                                                               :backward
                                                               :pacificnew
                                                               :systemv])]
                                          (b:run [:zic
                                                  :-L
                                                  :/dev/null
                                                  :-d
                                                  v-zoneinfo
                                                  :-y
                                                  "sh yearistype.sh"
                                                  v-tz]
                                                 {:cwd (.. (.. "../" b.name
                                                               :-build)
                                                           :/./tzdata)})
                                          (b:run [:zic
                                                  :-L
                                                  :/dev/null
                                                  :-d
                                                  (.. v-zoneinfo :/posix)
                                                  :-y
                                                  "sh yearistype.sh"
                                                  v-tz]
                                                 {:cwd (.. (.. "../" b.name
                                                               :-build)
                                                           :/./tzdata)})
                                          (b:run [:zic
                                                  :-L
                                                  :leapseconds
                                                  :-d
                                                  (.. v-zoneinfo :/right)
                                                  :-y
                                                  "sh yearistype.sh"
                                                  v-tz]
                                                 {:cwd (.. (.. "../" b.name
                                                               :-build)
                                                           :/./tzdata)}))
                                        (b:copy (b:join (b:join b.src
                                                                (.. (.. "../"
                                                                        b.name
                                                                        :-build)
                                                                    :/./tzdata))
                                                        :zone.tab)
                                                (b:join v-zoneinfo
                                                        (: (b:join (b:join b.src
                                                                           (.. (.. "../"
                                                                                   b.name
                                                                                   :-build)
                                                                               :/./tzdata))
                                                                   :zone.tab)
                                                           :match "[^/]+$")))
                                        (b:copy (b:join (b:join b.src
                                                                (.. (.. "../"
                                                                        b.name
                                                                        :-build)
                                                                    :/./tzdata))
                                                        :zone1970.tab)
                                                (b:join v-zoneinfo
                                                        (: (b:join (b:join b.src
                                                                           (.. (.. "../"
                                                                                   b.name
                                                                                   :-build)
                                                                               :/./tzdata))
                                                                   :zone1970.tab)
                                                           :match "[^/]+$")))
                                        (b:copy (b:join (b:join b.src
                                                                (.. (.. "../"
                                                                        b.name
                                                                        :-build)
                                                                    :/./tzdata))
                                                        :iso3166.tab)
                                                (b:join v-zoneinfo
                                                        (: (b:join (b:join b.src
                                                                           (.. (.. "../"
                                                                                   b.name
                                                                                   :-build)
                                                                               :/./tzdata))
                                                                   :iso3166.tab)
                                                           :match "[^/]+$")))
                                        (b:run [:zic
                                                :-d
                                                v-zoneinfo
                                                :-p
                                                :America/New_York]
                                               {:cwd (.. (.. "../" b.name
                                                             :-build)
                                                         :/./tzdata)})
                                        (set v-zoneinfo "")
                                        (if (b:exists (.. b.prefix
                                                          :/etc/localtime))
                                            (b:copy (.. b.prefix
                                                        :/share/zoneinfo/UTC)
                                                    (b:join (.. b.prefix
                                                                :/etc/localtime)
                                                            (: (.. b.prefix
                                                                   :/share/zoneinfo/UTC)
                                                               :match "[^/]+$")))
                                            (b:copy (.. b.prefix
                                                        :/share/zoneinfo/UTC)
                                                    (.. b.prefix
                                                        :/etc/localtime))))
                             :strip (fn [b]
                                      (b.default.strip b)
                                      ;; From do_end.
                                      )}}}
