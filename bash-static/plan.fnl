;; bash-static, ported from its plan.sh.
;; Built from the bash plan, with its own changes.
(var v-p "")
{:name :bash-static
 :origin :karate
 :version :4.4.19
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:gplv3+]
 :description "Bash is the GNU Project's shell. Bash is the Bourne Again SHell. Bash is an sh-compatible shell that incorporates useful features from the Korn shell (ksh) and C shell (csh). It is intended to conform to the IEEE POSIX P1003.2/ISO 9945.2 Shell and Tools standard. It offers functional improvements over sh for both programming and interactive use. In addition, most sh scripts can be run by Bash without modification."
 :upstream_url "http://www.gnu.org/software/bash/bash.html"
 :source {:url "http://ftp.gnu.org/gnu/bash/bash-4.4.tar.gz"
          :sha256 :d86b3392c1202e8ff5a423b302e6284db7f8f435ea9f39b5b1b20fd3ac36dfcb
          :dirname :bash-4.4}
 :build_deps [:karate/glibc
              :karate/ncurses
              :karate/readline
              :karate/coreutils
              :karate/diffutils
              :karate/patch
              :karate/make
              :karate/gcc]
 :bin_dirs [:bin]
 :interpreters [:bin/bash :bin/sh]
 :download (fn [b]
             ;; From do_begin.
             ;; The plan pointed its plan directory at bash's; nothing it runs reads from there.
             (b.default.download b)
             (let [v--patch-filess []
                   v--patch-shasumss []]
               (for [n 1 0]
                 (set v-p (. v--patch-filess n))
                 (b:download v-p (. v--patch-shasumss n)
                             (: (v-p:gsub "/+$" "") :match "[^/]*$"))))
             (set v-p ""))
 :verify (fn [b]
           (b.default.verify b)
           (for [_n 1 0]
             nil))
 :prepare (fn [b]
            (b.default.prepare b)
            (each [_ v-p (ipairs [])]
              (b:log (.. "Applying patch "
                         (: (v-p:gsub "/+$" "") :match "[^/]*$")))
              (b:run [:patch
                      :-p0
                      :-i
                      (.. b.cache "/" (: (v-p:gsub "/+$" "") :match "[^/]*$"))])))
 :build (fn [b]
          (b:run [:./configure
                  (.. :--prefix= b.prefix)
                  :--with-curses
                  :--enable-readline
                  :--without-bash-malloc
                  (.. :--with-installed-readline= (b:path_for :karate/readline))
                  (.. "LDFLAGS=-static " (or (b:getenv :LDFLAGS) ""))])
          (let [text (b:read (b:join b.src :Makefile))
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
                                  (string.gsub line "^TERMCAP_LIB = %-lcurses$"
                                               "TERMCAP_LIB = -ltinfow" 1))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join b.src :Makefile)
                     (.. (table.concat out "\n")
                         (if (and ends (> (length out) 0))
                             "\n"
                             ""))))
          (b:run [:make (.. "LDFLAGS=-static " (or (b:getenv :LDFLAGS) ""))]))
 :check (fn [b]
          (var v-clean-cmds "")
          (set v-clean-cmds [])
          (each [_ v-cmd (ipairs [:/bin/rm
                                  :/bin/cat
                                  :/bin/touch
                                  :/bin/chmod
                                  :/usr/bin/printf
                                  :/bin/echo])]
            (when (not (b:exists v-cmd))
              (let [link (if (b:exists (b:join v-cmd "."))
                             (b:join v-cmd
                                     (: (.. (b:path_for :coreutils) :/bin/
                                            (: (v-cmd:gsub "/+$" "") :match
                                               "[^/]*$"))
                                        :match "[^/]+$"))
                             v-cmd)]
                (b:symlink (.. (b:path_for :coreutils) :/bin/
                               (: (v-cmd:gsub "/+$" "") :match "[^/]*$"))
                           link))
              (set v-clean-cmds [v-cmd])))
          (b:run [:make :tests])
          (each [_ v-cmd (ipairs v-clean-cmds)]
            (b:remove v-cmd)))
 :install (fn [b]
            (b.default.install b)
            (let [link (if (b:exists (b:join (.. b.prefix :/bin/sh) "."))
                           (b:join (.. b.prefix :/bin/sh) :bash)
                           (.. b.prefix :/bin/sh))]
              (b:symlink :bash link)))}
