;; cockroach, ported from its plan.sh.
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

{:name :cockroach
 :origin :karate
 :version :2.1.6
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0]
 :description "CockroachDB is a cloud-native SQL database for building global, scalable cloud services that survive disasters."
 :upstream_url "https://github.com/cockroachdb/cockroach"
 :source {:url "https://binaries.cockroachdb.com/cockroach-v2.1.6.src.tgz"
          :sha256 :04a399a619fc898fbd457c60784416e17af22b05f02be101b2fe64c536163eeb
          :dirname :cockroach-v2.1.6}
 :deps [:karate/chrony :karate/gcc-libs :karate/glibc :karate/ncurses]
 :build_deps [:karate/autoconf
              :karate/cmake
              :karate/coreutils
              :karate/diffutils
              :karate/go
              :karate/gcc
              :karate/git
              :karate/libedit
              :karate/make
              :karate/procps-ng
              :karate/which]
 :bin_dirs [:bin]
 :exports {:port :port :http-port :http-port}
 :prepare (fn [b]
            (use-dependency-path b :/usr/bin/env
                                 (b:path_for :coreutils :bin/env)))
 :build (fn [b]
          (b:env :LIBRARY_PATH (or (b:getenv :LD_RUN_PATH) ""))
          (b:run [:make (.. :--jobs= (tostring b.jobs)) :buildoss]))
 :install (fn [b]
            (b:copy (b:join (b:join b.src
                                    :./src/github.com/cockroachdb/cockroach)
                            :cockroachoss)
                    (b:join (.. b.prefix :/bin/)
                            (: (b:join (b:join b.src
                                               :./src/github.com/cockroachdb/cockroach)
                                       :cockroachoss)
                               :match "[^/]+$")))
            (each [_ p (ipairs (b:glob (b:join (b:join b.src
                                                       :./src/github.com/cockroachdb/cockroach)
                                               :bin)
                                       "*"))]
              (b:copy p (b:join (.. b.prefix :/bin/) (: p :match "[^/]+$")))))
 :strip (fn [b]
          (b.default.strip b)
          ;; From do_end.
          )}
