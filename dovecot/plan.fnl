;; dovecot, ported from its plan.sh.
(fn use-dependency-path [b path replacement]
  ;; The source project's studio linked a dependency's tool to `path` for the
  ;; build. A Dojo build writes nothing outside itself, so the build's scripts
  ;; name the dependency's tool instead.
  (each [_ f (ipairs (b:find b.src "*"))]
    (let [name (: f :match "[^/]+$")]
      (when (and (or (: name :match :^configure) (: name :match :^Makefile)
                     (: name :match :^ltmain) (: name :match "%.in$")
                     (: name :match "%.am$") (: name :match "%.ac$")
                     (: name :match "%.m4$") (: name :match "%.mk$")
                     (: name :match "%.sh$") (: name :match "%.pl$")
                     (: name :match "%.py$"))
                 (not (b:exists (b:join f "."))))
        (let [text (b:read f)
              escaped (pick-values 1
                                   (: path :gsub "[%^%$%(%)%%%.%[%]%*%+%-%?]"
                                      "%%%0"))
              (fixed n) (: text :gsub escaped
                           (pick-values 1 (: replacement :gsub "%%" "%%%%")))]
          (when (> n 0) (b:write f fixed)))))))

{:name :dovecot
 :origin :karate
 :version :2.3.4
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:LGPL-2.1 :MIT]
 :description "Secure IMAP server"
 :upstream_url "https://dovecot.org"
 :source {:url "https://dovecot.org/releases/2.3/dovecot-2.3.4.tar.gz"
          :sha256 :d91b76eff8df6185c1799f1b279f780105bdeeea27e3286b42f4cab18efbef05}
 :deps [:karate/bzip2
        :karate/glibc
        :karate/linux-pam
        :karate/lz4
        :karate/openssl
        :karate/zlib]
 :build_deps [:karate/diffutils
              :karate/file
              :karate/gcc
              :karate/make
              :karate/pkg-config]
 :bin_dirs [:bin :sbin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :prepare (fn [b]
            (b:env :CFLAGS (.. (or (b:getenv :CFLAGS) "") " -O2"))
            (b:env :CXXFLAGS (.. (or (b:getenv :CXXFLAGS) "") " -O2"))
            (use-dependency-path b :/usr/bin/file (b:path_for :file :bin/file)))
 :strip (fn [b]
          (b.default.strip b)
          ;; From do_end.
          )}
