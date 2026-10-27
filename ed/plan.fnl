;; ed, ported from its plan.sh.
{:name :ed
 :origin :karate
 :version :1.15
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-3.0]
 :description "The standard text editor."
 :upstream_url "https://www.gnu.org/software/ed/"
 :source {:url "https://ftp.gnu.org/gnu/ed/ed-1.15.tar.lz"
          :sha256 :ad4489c0ad7a108c514262da28e6c2a426946fb408a3977ef1ed34308bdfd174}
 :deps [:karate/glibc]
 :build_deps [:karate/gcc :karate/make :karate/lzip :karate/diffutils]
 :bin_dirs [:bin]
 :unpack (fn [b]
           (b:mkdir (.. b.cache "/" (.. b.name "-" b.version)))
           (b:run [:tar
                   :--lzip
                   :-xf
                   (.. b.cache "/" (.. b.name "-" b.version :.tar.lz))
                   :-C
                   b.cache]))
 :check (fn [b]
          (b:run [:make :check]))}
