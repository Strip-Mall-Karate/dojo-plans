;; apr, ported from its plan.sh.
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

{:name :apr
 :origin :karate
 :version :1.6.5
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0]
 :description "Apache Portable Runtime"
 :upstream_url "https://apr.apache.org/"
 :source {:url "https://archive.apache.org/dist/apr/apr-1.6.5.tar.bz2"
          :sha256 :a67ca9fcf9c4ff59bce7f428a323c8b5e18667fdea7b0ebad47d194371b0a105}
 :deps [:karate/gcc-libs
        :karate/glibc
        :karate/sed
        :karate/grep
        :karate/binutils
        :karate/coreutils]
 :build_deps [:karate/diffutils
              :karate/file
              :karate/gcc
              :karate/iana-etc
              :karate/libossp-uuid
              :karate/make]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]
 :prepare (fn [b]
            (b:env :LDFLAGS (.. "-lgcc_s " (or (b:getenv :LDFLAGS) "")))
            (use-dependency-path b :/usr/bin/file (b:path_for :file :bin/file)))
 :check (fn [b]
          (var v-clean-services "")
          ;; The plan copied iana-etc's services file to /etc/services for the tests when it
          ;; was missing. A Dojo build writes nothing outside itself; the tests need a
          ;; services file where the build runs.
          (b:run [:make :test]))
 :strip (fn [b]
          (b.default.strip b)
          ;; From do_end.
          )}
