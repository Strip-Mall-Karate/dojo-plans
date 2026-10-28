;; expat, ported from its plan.sh.
;; expat 2.9.0, the latest release on 2026-10-26: 2.2.5's source no longer downloads.
{:name :expat
 :origin :karate
 :version :2.9.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "Expat is a stream-oriented XML parser library written in C. Expat excels with files too large to fit RAM, and where performance and flexibility are crucial."
 :upstream_url "https://libexpat.github.io/"
 :source {:url "https://github.com/libexpat/libexpat/releases/download/R_2_9_0/expat-2.9.0.tar.xz"
          :sha256 :1e6371862cc31999b368c3b89b49994f0677e1bab5f1b2b85ae3741f5d803051}
 :deps [:karate/glibc :karate/gcc-libs]
 :build_deps [:karate/coreutils
              :karate/diffutils
              :karate/patch
              :karate/make
              :karate/gcc]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]
 :check (fn [b]
          (let [text (b:read (b:join b.src :run.sh))
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
                (set line (pick-values 1 (string.gsub line "^#!.*bash$" "" 1))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join b.src :run.sh)
                     (.. (table.concat out "\n")
                         (if (and ends (> (length out) 0))
                             "\n"
                             ""))))
          (b:run [:make
                  :check
                  (.. :LDFLAGS= (or (b:getenv :LDFLAGS) "") " -lstdc++")]))
 :install (fn [b]
            (b.default.install b)
            ;; The plan named $pkgdir, which nothing sets, so the source project's builder
            ;; installed this to /share/licenses; the license belongs in the package.
            (b:copy (b:join b.src :COPYING)
                    (.. b.prefix :/share/licenses/COPYING))
            (b:chmod (.. b.prefix :/share/licenses/COPYING) :644))}
