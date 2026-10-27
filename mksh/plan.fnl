;; mksh, ported from its plan.sh.
;; mksh R59c, the latest release on 2026-10-26: R56c's source no longer downloads.
{:name :mksh
 :origin :karate
 :version :R59c
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MirOS :ISC :BSD-3-Clause]
 :description "The MirBSD Korn Shell"
 :upstream_url "http://www.mirbsd.org/mksh.htm"
 :source {:url "https://deb.debian.org/debian/pool/main/m/mksh/mksh_59c.orig.tar.gz"
          :sha256 :77ae1665a337f1c48c61d6b961db3e52119b38e58884d1c89684af31f87bc506
          :filename :mksh-R59c.tar.gz
          :dirname :mksh}
 :deps [:karate/glibc]
 :build_deps [:karate/make :karate/gcc :karate/gawk :karate/wget]
 :bin_dirs [:bin]
 :interpreters [:bin/ksh :bin/mksh]
 :build (fn [b]
          (b:run [:sh :Build.sh :-r]))
 :install (fn [b]
            (b:copy (b:join b.src :mksh) (.. b.prefix :/bin/mksh))
            (b:chmod (.. b.prefix :/bin/mksh) :755)
            (let [link (if (b:exists (b:join (b:join (.. b.prefix :/bin) :ksh)
                                             "."))
                           (b:join (b:join (.. b.prefix :/bin) :ksh) :mksh)
                           (b:join (.. b.prefix :/bin) :ksh))]
              (b:symlink :mksh link))
            (b:mkdir (.. b.prefix :/share))
            (b:run [:wget
                    "https://www.mirbsd.org/TaC-mksh.txt"
                    :-O
                    (.. b.prefix :/share/TaC-mksh.txt)]))}
