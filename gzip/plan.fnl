;; gzip, ported from its plan.sh.
;; gzip 1.15, the latest release on 2026-10-26.
{:name :gzip
 :origin :karate
 :version :1.15
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:gplv3+]
 :description "GNU Gzip is a popular data compression program originally written by Jean-loup Gailly for the GNU project."
 :upstream_url "https://www.gnu.org/software/gzip/"
 :source {:url "https://ftp.gnu.org/gnu/gzip/gzip-1.15.tar.xz"
          :sha256 :9aa0cc780dec156b8282844833b342ab7cb08c25d2cd9a1869cdd0df31deff48}
 :deps [:karate/glibc :karate/less :karate/grep]
 :build_deps [:karate/coreutils
              :karate/diffutils
              :karate/patch
              :karate/make
              :karate/gcc
              :karate/sed
              :karate/xz]
 :bin_dirs [:bin]
 :prepare (fn [b]
            (b.default.prepare b)
            (b:log "Patching 'zless' with the full path to 'less'")
            (let [text (b:read (b:join b.src :zless.in))
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
                                    (string.gsub line "less %-V"
                                                 (.. (pick-values 1
                                                                  (: (b:path_for :less)
                                                                     :gsub "%%"
                                                                     "%%%%"))
                                                     "/bin/less -V")))))
                (when (not deleted)
                  (set line
                       (pick-values 1
                                    (string.gsub line "exec less"
                                                 (.. "exec "
                                                     (pick-values 1
                                                                  (: (b:path_for :less)
                                                                     :gsub "%%"
                                                                     "%%%%"))
                                                     :/bin/less)))))
                (when (not deleted) (table.insert out line))
                (each [_ x (ipairs after)] (table.insert out x)))
              (b:write (b:join b.src :zless.in)
                       (.. (table.concat out "\n")
                           (if (and ends (> (length out) 0))
                               "\n"
                               "")))))
 :build (fn [b]
          (b:run [:./configure (.. :--prefix= b.prefix)])
          (b:run [:make
                  (.. :-j (tostring b.jobs))
                  (.. :GREP= (b:path_for :grep) :/bin/grep)
                  (.. :LESS= (b:path_for :less) :/bin/less)]))
 :check (fn [b]
          (let [text (b:read (b:join b.src :tests/Makefile))
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
                (set line (pick-values 1 (string.gsub line :zmore ""))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join b.src :tests/Makefile)
                     (.. (table.concat out "\n")
                         (if (and ends (> (length out) 0))
                             "\n"
                             ""))))
          (b:run [:make :check]))}
