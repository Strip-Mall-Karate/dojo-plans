;; tar, ported from its plan.sh.
{:name "tar"
 :origin "karate"
 :version "1.30"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-3.0"]
 :description "GNU Tar provides the ability to create tar archives, as well as various other kinds of manipulation."
 :upstream_url "https://www.gnu.org/software/tar/"
 :source {:url "http://ftp.gnu.org/gnu/tar/tar-1.30.tar.gz" :sha256 "4725cc2c2f5a274b12b39d1f78b3545ec9ebb06a6e48e8845e1995ac8513b088"}
 :deps ["karate/glibc" "karate/acl" "karate/attr"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/sed"]
 :bin_dirs ["bin"]
 :prepare (fn [b]
          (b:run ["patch" "-p1" "-i" (.. b.plan_dir "/skip-test.patch")]))
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix)] {:env {"FORCE_UNSAFE_CONFIGURE" "1"}})
          (b:run ["make"]))
 :check (fn [b]
          (b:run ["make" "check"]))}
