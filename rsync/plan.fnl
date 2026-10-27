;; rsync, ported from its plan.sh.
{:name :rsync
 :origin :karate
 :version :3.1.2
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-3.0]
 :description "An open source utility that provides fast incremental file transfer"
 :upstream_url "https://rsync.samba.org/"
 :source {:url "https://download.samba.org/pub/rsync/src/rsync-3.1.2.tar.gz"
          :sha256 :ecfa62a7fa3c4c18b9eccd8c16eaddee4bd308a76ea50b5c02a5840f09c0a1c2}
 :deps [:karate/glibc :karate/perl :karate/acl :karate/attr]
 :build_deps [:karate/make :karate/gcc :karate/perl :karate/diffutils]
 :bin_dirs [:bin]
 :check (fn [b]
          (b:run [:make :check]))}
