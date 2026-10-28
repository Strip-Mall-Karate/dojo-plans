;; lsof, ported from its plan.sh.
{:name :lsof
 :origin :karate
 :version :4.91
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:lsof]
 :description "lsof - list open files"
 :upstream_url "https://people.freebsd.org/~abe/"
 :source {:url "https://www.mirrorservice.org/sites/lsof.itap.purdue.edu/pub/tools/unix/lsof/lsof_4.91.tar.bz2"
          :sha256 :c9da946a525fbf82ff80090b6d1879c38df090556f3fe0e6d782cb44172450a3
          :dirname :lsof_4.91}
 :deps [:karate/glibc]
 :build_deps [:karate/coreutils
              :karate/make
              :karate/gcc
              :karate/busybox-static]
 :bin_dirs [:bin]
 :unpack (fn [b]
           (b.default.unpack b)
           ;; $_tar_cmd was the source project's builder's tar.
           (b:run [:tar
                   :xf
                   (b:join b.src (.. b.name "_" b.version :_src.tar))
                   :-C
                   b.src
                   :--strip-components=1]))
 :build (fn [b]
          (b:env :DESTDIR (or (b:getenv :PREFIX) ""))
          (b:env :LSOF_CFLAGS_OVERRIDE :1)
          (local v-lsof-include (.. (b:path_for :glibc) :/include/))
          (b:env :LSOF_INCLUDE v-lsof-include)
          (b:chmod (b:join b.src :Configure) :+x)
          (b:run [:./Configure :linux :-n] {:cwd b.src})
          (b:run [:make (.. :-j (tostring b.jobs))] {:cwd b.src}))
 :install (fn [b]
            (b:copy (.. b.src "/" b.name)
                    (b:join (.. (or (b:getenv :PREFIX) "") :/bin)
                            (: (.. b.src "/" b.name) :match "[^/]+$")))
            (b:chmod (b:join (.. (or (b:getenv :PREFIX) "") :/bin)
                             (: (.. b.src "/" b.name) :match "[^/]+$"))
                     :0755))}
