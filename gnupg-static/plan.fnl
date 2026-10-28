;; gnupg-static, ported from its plan.sh.
;; gnupg-static 1.4.23, the latest release on 2026-10-26: 1.4.20's source no longer downloads.
;; Built from the gnupg plan, with its own changes.
{:name :gnupg-static
 :origin :karate
 :version :1.4.23
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:gplv3+]
 :source {:url "https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-1.4.23.tar.bz2"
          :sha256 :c9462f17e651b6507848c08c430c791287cd75491f8b5a8b50c6ed46b12678ba
          :dirname :gnupg-1.4.23}
 :build_deps [:karate/glibc
              :karate/zlib
              :karate/bzip2
              :karate/readline
              :karate/coreutils
              :karate/diffutils
              :karate/patch
              :karate/make
              :karate/gcc
              :karate/sed
              :karate/findutils]
 :bin_dirs [:bin]
 :prepare (fn [b]
            (b:env :LDFLAGS (.. "-static " (or (b:getenv :LDFLAGS) "")))
            (b:log (.. "Updating LDFLAGS=" (or (b:getenv :LDFLAGS) ""))))
 :build (fn [b]
          (b:run [:./configure
                  (.. :--prefix= b.prefix)
                  (.. :--sbindir= b.prefix :/bin)])
          (b:run [:make]))
 :check (fn [b]
          ;; find tests -type f | xargs sed: each file under tests, /bin/pwd made coreutils' pwd.
          (let [pwd (.. (b:path_for :coreutils) :/bin/pwd)]
            (each [_ f (ipairs (b:find (b:join b.src :tests) "*"))]
              (when (not (b:exists (b:join f ".")))
                (let [text (b:read f)
                      (fixed n) (text:gsub :/bin/pwd
                                           (pick-values 1
                                                        (pwd:gsub "%%" "%%%%")))]
                  (when (> n 0) (b:write f fixed))))))
          (b:run [:make :check]))}
