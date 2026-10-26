;; sqlite, ported from its plan.sh.
{:name "sqlite"
 :origin "karate"
 :version "3130000"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Public Domain"]
 :description "A software library that implements a self-contained, serverless, zero-configuration, transactional SQL database engine."
 :upstream_url "https://www.sqlite.org/"
 :source {:url "https://www.sqlite.org/2016/sqlite-autoconf-3130000.tar.gz" :sha256 "e2797026b3310c9d08bd472f6d430058c6dd139ff9d4e30289884ccd9744086b" :filename "sqlite-autoconf-3130000.tar.gz" :dirname "sqlite-autoconf-3130000"}
 :deps ["karate/glibc" "karate/readline"]
 :build_deps ["karate/gcc" "karate/make" "karate/coreutils"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]}
