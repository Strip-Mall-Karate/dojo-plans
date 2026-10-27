;; sqlite, ported from its plan.sh.
;; sqlite 3.54.1, the latest release on 2026-10-27.
{:name :sqlite
 :origin :karate
 :version :3540100
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license ["Public Domain"]
 :description "A software library that implements a self-contained, serverless, zero-configuration, transactional SQL database engine."
 :upstream_url "https://www.sqlite.org/"
 :source {:url "https://www.sqlite.org/2026/sqlite-autoconf-3540100.tar.gz"
          :sha256 :926ef8d3eab93fbf6e06011901273eec076b25594a4e1cdadd50c987f4f6d64e
          :filename :sqlite-autoconf-3540100.tar.gz
          :dirname :sqlite-autoconf-3540100}
 :deps [:karate/glibc :karate/readline]
 :build_deps [:karate/gcc :karate/make :karate/coreutils]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]}
