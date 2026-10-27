;; gperftools, ported from its plan.sh.
{:name :gperftools
 :origin :karate
 :version :2.7
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:BSDv3]
 :description "Google Performance Tools"
 :upstream_url "https://github.com/gperftools/gperftools"
 :source {:url "https://github.com/gperftools/gperftools/releases/download/gperftools-2.7/gperftools-2.7.tar.gz"
          :sha256 :1ee8c8699a0eff6b6a203e59b43330536b22bbcbe6448f54c7091e5efb0763c9}
 :deps [:karate/glibc
        :karate/gcc-libs
        :karate/graphviz
        :karate/coreutils
        :karate/grep
        :karate/perl
        :karate/binutils]
 :build_deps [:karate/gcc :karate/make :karate/automake]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :build (fn [b]
          (b.default.build b)
          (b:fix_interpreter [(b:join b.src :src/pprof)] :karate/coreutils
                             :bin/env)
          (let [text (b:read (b:join b.src :src/pprof))
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
                                  (string.gsub line "\"objdump\","
                                               (.. "\""
                                                   (pick-values 1
                                                                (: (b:path_for :karate/binutils)
                                                                   :gsub "%%"
                                                                   "%%%%"))
                                                   "/bin/objdump\",")
                                               1))))
              (when (not deleted)
                (set line
                     (pick-values 1
                                  (string.gsub line "\"nm\","
                                               (.. "\""
                                                   (pick-values 1
                                                                (: (b:path_for :karate/binutils)
                                                                   :gsub "%%"
                                                                   "%%%%"))
                                                   "/bin/nm\",")
                                               1))))
              (when (not deleted)
                (set line
                     (pick-values 1
                                  (string.gsub line "\"addr2line\","
                                               (.. "\""
                                                   (pick-values 1
                                                                (: (b:path_for :karate/binutils)
                                                                   :gsub "%%"
                                                                   "%%%%"))
                                                   "/bin/addr2line\",")
                                               1))))
              (when (not deleted)
                (set line
                     (pick-values 1
                                  (string.gsub line "\"c%+%+filt\","
                                               (.. "\""
                                                   (pick-values 1
                                                                (: (b:path_for :karate/binutils)
                                                                   :gsub "%%"
                                                                   "%%%%"))
                                                   "/bin/c++filt\",")
                                               1))))
              (when (not deleted)
                (set line
                     (pick-values 1
                                  (string.gsub line "ShellEscape%(\"grep\""
                                               (.. "ShellEscape(\""
                                                   (pick-values 1
                                                                (: (b:path_for :karate/grep)
                                                                   :gsub "%%"
                                                                   "%%%%"))
                                                   "/bin/grep\"")
                                               1))))
              (when (not deleted)
                (set line
                     (pick-values 1
                                  (string.gsub line "ShellEscape%(\"tail\""
                                               (.. "ShellEscape(\""
                                                   (pick-values 1
                                                                (: (b:path_for :karate/coreutils)
                                                                   :gsub "%%"
                                                                   "%%%%"))
                                                   "/bin/tail\"")
                                               1))))
              (when (not deleted)
                (set line
                     (pick-values 1
                                  (string.gsub line "%(\"dot\"%)"
                                               (.. "(\""
                                                   (pick-values 1
                                                                (: (b:path_for :karate/graphviz)
                                                                   :gsub "%%"
                                                                   "%%%%"))
                                                   "/bin/dot\")")
                                               1))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join b.src :src/pprof)
                     (.. (table.concat out "\n")
                         (if (and ends (> (length out) 0))
                             "\n"
                             "")))))
 :check (fn [b]
          (b:run [:make :check]))}
