;; mawk, ported from its plan.sh.
{:name :mawk
 :origin :karate
 :version :1.3.4-20161120
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-2.0]
 :description "An interpreter for the AWK Programming Language"
 :upstream_url "http://invisible-island.net/mawk/mawk.html"
 :source {:url "https://invisible-mirror.net/archives/mawk/mawk-1.3.4-20161120.tgz"
          :sha256 :361ec1bb4968c1f1f3b91b77493cf11b31c73ff8516f95db30e4dc28de180c1e}
 :deps [:karate/glibc]
 :build_deps [:karate/diffutils :karate/gcc :karate/make]
 :bin_dirs [:bin]
 :check (fn [b]
          (each [_ v-file (ipairs [:test/mawktest :test/fpe_test])]
            (let [text (b:read (if (= (: v-file :sub 1 1) "/") v-file
                                   (b:join b.src v-file)))
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
                                    (string.gsub line "PATH=/bin:/usr/bin"
                                                 (.. "PATH=/bin:/usr/bin:"
                                                     (pick-values 1
                                                                  (: (or (b:getenv :PATH)
                                                                         "")
                                                                     :gsub "%%"
                                                                     "%%%%")))))))
                (when (not deleted) (table.insert out line))
                (each [_ x (ipairs after)] (table.insert out x)))
              (b:write (if (= (: v-file :sub 1 1) "/") v-file
                           (b:join b.src v-file))
                       (.. (table.concat out "\n")
                           (if (and ends (> (length out) 0))
                               "\n"
                               "")))))
          (b:run [:make :check]))}
