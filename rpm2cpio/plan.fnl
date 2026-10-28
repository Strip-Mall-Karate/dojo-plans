;; rpm2cpio, ported from its plan.sh.
{:name :rpm2cpio
 :origin :karate
 :version :1.3
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:BSD]
 :description "Simple Perl-based rpm2cpio utility"
 :upstream_url "https://svnweb.freebsd.org/ports/head/archivers/rpm2cpio/"
 :source {:url "https://svnweb.freebsd.org/ports/head/archivers/rpm2cpio/files/rpm2cpio?revision=340851"
          :sha256 :09651201a34771774fc4feaf5b409717e4bc052b82a89f3fc17c0cf578f8e608
          :filename :rpm2cpio-1.3.pl}
 :deps [:karate/perl :karate/gzip :karate/xz :karate/bzip2]
 :build_deps [:karate/patch :karate/sed]
 :bin_dirs [:bin]
 :unpack (fn [_b]
           nil)
 :prepare (fn [b]
            (if (b:exists (b:join b.src :rpm2cpio))
                (b:copy (b:join b.src :../rpm2cpio-1.3.pl)
                        (b:join (b:join b.src :rpm2cpio)
                                (: (b:join b.src :../rpm2cpio-1.3.pl) :match
                                   "[^/]+$")))
                (b:copy (b:join b.src :../rpm2cpio-1.3.pl)
                        (b:join b.src :rpm2cpio)))
            (b:run [:patch :-p0]
                   {:stdin (let [text (b:read (.. b.plan_dir :/doj-path.patch))
                                 ends (= (text:sub -1) "\n")
                                 lines []
                                 out []]
                             (each [l (string.gmatch (if ends text
                                                         (.. text "\n"))
                                                     "(.-)\n")]
                               (table.insert lines l))
                             (each [_n l (ipairs lines)]
                               (var line l)
                               (local deleted false)
                               (local after [])
                               (when (not deleted)
                                 (set line
                                      (pick-values 1
                                                   (string.gsub line
                                                                "%%%%gzip%%%%"
                                                                (.. (pick-values 1
                                                                                 (: (b:path_for :gzip)
                                                                                    :gsub
                                                                                    "%%"
                                                                                    "%%%%"))
                                                                    :/bin/gzip)))))
                               (when (not deleted)
                                 (set line
                                      (pick-values 1
                                                   (string.gsub line
                                                                "%%%%xz%%%%"
                                                                (.. (pick-values 1
                                                                                 (: (b:path_for :xz)
                                                                                    :gsub
                                                                                    "%%"
                                                                                    "%%%%"))
                                                                    :/bin/xz)))))
                               (when (not deleted)
                                 (set line
                                      (pick-values 1
                                                   (string.gsub line
                                                                "%%%%bzip2%%%%"
                                                                (.. (pick-values 1
                                                                                 (: (b:path_for :bzip2)
                                                                                    :gsub
                                                                                    "%%"
                                                                                    "%%%%"))
                                                                    :/bin/bzip2)))))
                               (when (not deleted)
                                 (set line
                                      (pick-values 1
                                                   (string.gsub line
                                                                "%%%%lzma%%%%"
                                                                (.. (pick-values 1
                                                                                 (: (b:path_for :xz)
                                                                                    :gsub
                                                                                    "%%"
                                                                                    "%%%%"))
                                                                    :/bin/lzma)))))
                               (when (not deleted) (table.insert out line))
                               (each [_ x (ipairs after)] (table.insert out x)))
                             (.. (table.concat out "\n")
                                 (if (and ends (> (length out) 0))
                                     "\n"
                                     "")))})
            (b:fix_interpreter [(b:join b.src :rpm2cpio)] :karate/perl
                               :bin/perl))
 :build (fn [_b]
          nil)
 :install (fn [b]
            (b:copy (b:join b.src :rpm2cpio) (.. b.prefix :/bin/rpm2cpio))
            (b:chmod (.. b.prefix :/bin/rpm2cpio) :0755))}
