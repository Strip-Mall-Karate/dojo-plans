;; tar, ported from its plan.sh.
;; tar 1.35, the latest release on 2026-10-26.
{:name "tar"
 :origin "karate"
 :version "1.35"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-3.0"]
 :description "GNU Tar provides the ability to create tar archives, as well as various other kinds of manipulation."
 :upstream_url "https://www.gnu.org/software/tar/"
 :source {:url "https://ftp.gnu.org/gnu/tar/tar-1.35.tar.xz" :sha256 "4d62ff37342ec7aed748535323930c7cf94acf71c3591882b26a7ea50f3edc16"}
 :deps ["karate/glibc" "karate/acl" "karate/attr"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/sed"]
 :bin_dirs ["bin"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix)] {:env {"FORCE_UNSAFE_CONFIGURE" "1"}})
          (b:run ["make"]))
 :check (fn [b]
          (b:run ["make" "check"]))}
