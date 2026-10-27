;; expect, ported from its plan.sh.
;; expect 5.45.4, the latest release on 2026-10-26.
{:name :expect
 :origin :karate
 :version :5.45.4
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:custom]
 :description "Expect is a tool for automating interactive applications such as telnet, ftp, passwd, fsck, rlogin, tip, etc. Expect really makes this stuff trivial. Expect is also useful for testing these same applications."
 :upstream_url "https://www.nist.gov/services-resources/software/expect"
 :source {:url "https://downloads.sourceforge.net/project/expect/Expect/5.45.4/expect5.45.4.tar.gz"
          :sha256 :49a7da83b0bdd9f46d04a04deec19c7767bb9a323e40c4781f89caf760b92c34
          :dirname :expect5.45.4}
 :deps [:karate/gcc-libs :karate/glibc :karate/tcl :karate/zlib]
 :build_deps [:karate/coreutils
              :karate/diffutils
              :karate/gcc
              :karate/make
              :karate/patch]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :prepare (fn [b]
            (b.default.prepare b)
            (let [text (b:read (b:join b.src :configure))
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
                                    (string.gsub line :/bin/stty
                                                 (.. (pick-values 1
                                                                  (: (b:path_for :coreutils)
                                                                     :gsub "%%"
                                                                     "%%%%"))
                                                     :/bin/stty)))))
                (when (not deleted) (table.insert out line))
                (each [_ x (ipairs after)] (table.insert out x)))
              (b:write (b:join b.src :configure)
                       (.. (table.concat out "\n")
                           (if (and ends (> (length out) 0))
                               "\n"
                               "")))))
 :build (fn [b]
          ;; expect 5.45.4's configure probes use implicit declarations, which gcc 14 and later
          ;; reject; with them failing it cannot pick a pty implementation.
          (b:env :CFLAGS
                 (.. (or (b:getenv :CFLAGS) "") " -std=gnu17 -fpermissive"))
          (b:run [:./configure
                  (.. :--prefix= b.prefix)
                  (.. :--exec-prefix= b.prefix)
                  (.. :--with-tcl= (b:path_for :tcl) :/lib)
                  (.. :--with-tclinclude= (b:path_for :tcl) :/include)])
          (b:run [:make]))
 :check (fn [b]
          (b:run [:make :test]))
 :install (fn [b]
            (b:run [:make :install])
            (b:run [:find
                    (.. b.prefix :/bin)
                    :-type
                    :f
                    :-exec
                    :sed
                    :-e
                    (.. "s,exec tclsh,exec " (b:path_for :tcl) "/bin/tclsh,g")
                    :-i
                    "{}"
                    ";"]))}
