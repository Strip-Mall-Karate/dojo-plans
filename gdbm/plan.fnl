;; gdbm, ported from its plan.sh.
;; gdbm 1.26, the latest release on 2026-10-26.
{:name :gdbm
 :origin :karate
 :version :1.26
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:gplv3+]
 :description "GNU dbm is a set of database routines that use extensible hashing. It works similar to the standard UNIX dbm routines."
 :upstream_url "http://www.gnu.org/software/gdbm/gdbm.html"
 :source {:url "https://ftp.gnu.org/gnu/gdbm/gdbm-1.26.tar.gz"
          :sha256 :6a24504a14de4a744103dcb936be976df6fbe88ccff26065e54c1c47946f4a5e}
 :deps [:karate/glibc]
 :build_deps [:karate/coreutils
              :karate/diffutils
              :karate/patch
              :karate/make
              :karate/gcc]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :build (fn [b]
          (b:run [:./configure
                  (.. :--prefix= b.prefix)
                  :--enable-libgdbm-compat])
          (b:run [:make]))
 :check (fn [b]
          (b:run [:make :check]))
 :install (fn [b]
            (b.default.install b)
            (b:mkdir (.. b.prefix :/include/gdbm))
            (b:chmod (.. b.prefix :/include/gdbm) :755)
            (let [link (if (b:exists (b:join (.. b.prefix :/include/gdbm/gdbm.h)
                                             "."))
                           (b:join (.. b.prefix :/include/gdbm/gdbm.h) :gdbm.h)
                           (.. b.prefix :/include/gdbm/gdbm.h))]
              (b:remove link)
              (b:symlink :../gdbm.h link))
            (let [link (if (b:exists (b:join (.. b.prefix :/include/gdbm/ndbm.h)
                                             "."))
                           (b:join (.. b.prefix :/include/gdbm/ndbm.h) :ndbm.h)
                           (.. b.prefix :/include/gdbm/ndbm.h))]
              (b:remove link)
              (b:symlink :../ndbm.h link))
            (let [link (if (b:exists (b:join (.. b.prefix :/include/gdbm/dbm.h)
                                             "."))
                           (b:join (.. b.prefix :/include/gdbm/dbm.h) :dbm.h)
                           (.. b.prefix :/include/gdbm/dbm.h))]
              (b:remove link)
              (b:symlink :../dbm.h link)))}
