;; freetds, ported from its plan.sh.
{:name "freetds"
 :origin "karate"
 :version "1.00.109"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["LGPL2"]
 :description "FreeTDS is a set of libraries for Unix and Linux that allows your programs to natively talk to Microsoft SQL Server and Sybase databases."
 :upstream_url "http://www.freetds.org"
 :source {:url "http://www.freetds.org/files/stable/freetds-1.00.109.tar.bz2" :sha256 "3e93b2bcdddc7246147398b9bc3b989c6e7ffed54acbce18f4f34b745c8f0034"}
 :deps ["karate/glibc" "karate/libtool" "karate/openssl" "karate/unixodbc" "karate/zlib"]
 :build_deps ["karate/binutils" "karate/gcc" "karate/make"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--enable-msdblib" (.. "--with-unixodbc=" (b:path_for "unixodbc")) (.. "--with-openssl=" (b:path_for "openssl"))])
          (b:run ["make"]))}
