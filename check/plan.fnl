;; check, ported from its plan.sh.
;; check 0.15.2, the latest release on 2026-10-26.
{:name :check
 :origin :karate
 :version :0.15.2
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:LGPL-2.1-or-later]
 :description "Check is a unit testing framework for C. It features a simple interface for defining unit tests, putting little in the way of the developer. Tests are run in a separate address space, so both assertion failures and code errors that cause segmentation faults or other signals can be caught."
 :upstream_url "https://libcheck.github.io/check"
 :source {:url "https://github.com/libcheck/check/releases/download/0.15.2/check-0.15.2.tar.gz"
          :sha256 :a8de4e0bacfb4d76dd1c618ded263523b53b85d92a146d8835eb1a52932fa20a}
 :deps [:karate/gawk :karate/glibc]
 :build_deps [:karate/coreutils
              :karate/diffutils
              :karate/file
              :karate/gcc
              :karate/make
              :karate/sed]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]
 :prepare (fn [b]
            (let [text (b:read (b:join b.src :configure))
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
                       (pick-values 1 (string.gsub line :/usr/bin/file :file))))
                (when (not deleted) (table.insert out line))
                (each [_ x (ipairs after)] (table.insert out x)))
              (b:write (b:join b.src :configure)
                       (.. (table.concat out "\n")
                           (if (and ends (> (length out) 0))
                               "\n"
                               "")))))
 :check (fn [b]
          (var v--interpreter "")
          (set v--interpreter (.. (b:path_for :karate/coreutils) :/bin/env))
          (let [text (b:read (b:join b.src :checkmk/test/check_checkmk))
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
                                                                (v--interpreter:gsub "%%"
                                                                                     "%%%%")))
                                               1))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join b.src :checkmk/test/check_checkmk)
                     (.. (table.concat out "\n")
                         (if (and ends (> (length out) 0))
                             "\n"
                             ""))))
          (each [_ v-f (ipairs (b:glob (b:join b.src :tests) :test_*))]
            (let [text (b:read v-f)
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
                                                                  (v--interpreter:gsub "%%"
                                                                                       "%%%%")))
                                                 1))))
                (when (not deleted) (table.insert out line))
                (each [_ x (ipairs after)] (table.insert out x)))
              (b:write v-f (.. (table.concat out "\n")
                               (if (and ends (> (length out) 0))
                                   "\n"
                                   "")))))
          (b:run [:make :check]))
 :install (fn [b]
            (b.default.install b)
            (b:remove (.. b.prefix :/share/info/dir))
            (b:remove (.. b.prefix :/share/doc/check/*ChangeLog*)))}
