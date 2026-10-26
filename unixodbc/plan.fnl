;; unixodbc, ported from its plan.sh.
{:name "unixodbc"
 :origin "karate"
 :version "2.3.6"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["LGPL2.1"]
 :description "ODBC driver manager for Unix"
 :upstream_url "http://www.unixodbc.org/"
 :source {:url "ftp://ftp.unixodbc.org/pub/unixODBC/unixODBC-2.3.6.tar.gz" :sha256 "88b637f647c052ecc3861a3baa275c3b503b193b6a49ff8c28b2568656d14d69" :dirname "unixODBC-2.3.6"}
 :deps ["karate/glibc" "karate/libtool"]
 :build_deps ["karate/binutils" "karate/gcc" "karate/make"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--disable-gui"])
          (b:run ["make"]))}
