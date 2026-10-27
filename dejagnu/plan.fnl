;; dejagnu, ported from its plan.sh.
;; dejagnu 1.6.3, the latest release on 2026-10-26.
{:name :dejagnu
 :origin :karate
 :version :1.6.3
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-3.0-or-later]
 :description "A framework for testing other programs."
 :upstream_url "https://www.gnu.org/software/dejagnu/"
 :source {:url "https://ftp.gnu.org/gnu/dejagnu/dejagnu-1.6.3.tar.gz"
          :sha256 :87daefacd7958b4a69f88c6856dbd1634261963c414079d0c371f589cd66a2e3}
 :deps [:karate/expect :karate/coreutils :karate/sed :karate/grep]
 :build_deps [:karate/diffutils :karate/patch :karate/make :karate/gcc]
 :bin_dirs [:bin]
 :include_dirs [:include]
 :check (fn [b]
          (b:run [:make :check]))
 :install (fn [b]
            (b.default.install b)
            (let [text (b:read (.. b.prefix :/bin/runtest))
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
                                    (string.gsub line :expectbin=expect
                                                 (.. :expectbin=
                                                     (pick-values 1
                                                                  (: (b:path_for :expect)
                                                                     :gsub "%%"
                                                                     "%%%%"))
                                                     :/bin/expect)))))
                (when (not deleted) (table.insert out line))
                (each [_ x (ipairs after)] (table.insert out x)))
              (b:write (.. b.prefix :/bin/runtest)
                       (.. (table.concat out "\n")
                           (if (and ends (> (length out) 0))
                               "\n"
                               "")))))}
