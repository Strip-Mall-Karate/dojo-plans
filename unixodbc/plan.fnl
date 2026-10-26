;; unixodbc, ported from its plan.sh.
;; unixodbc 2.3.14, the latest release on 2026-10-26: 2.3.6's source no longer downloads.
{:name "unixodbc"
 :origin "karate"
 :version "2.3.14"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["LGPL2.1"]
 :description "ODBC driver manager for Unix"
 :upstream_url "http://www.unixodbc.org/"
 :source {:url "https://www.unixodbc.org/unixODBC-2.3.14.tar.gz" :sha256 "4e2814de3e01fc30b0b9f75e83bb5aba91ab0384ee951286504bb70205524771" :dirname "unixODBC-2.3.14"}
 :deps ["karate/glibc" "karate/libtool"]
 :build_deps ["karate/binutils" "karate/gcc" "karate/make"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--disable-gui"])
          (b:run ["make"]))}
