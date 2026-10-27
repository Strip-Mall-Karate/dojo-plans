;; libxslt, ported from its plan.sh.
{:name :libxslt
 :origin :karate
 :version :1.1.33
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:libxslt]
 :description "Libxslt is the XSLT C library developed for the GNOME project"
 :upstream_url "http://xmlsoft.org/XSLT/"
 :source {:url "http://xmlsoft.org/sources/libxslt-1.1.33.tar.gz"
          :sha256 :8e36605144409df979cab43d835002f63988f3dc94d5d3537c12796db90e38c8
          :filename :libxslt-1.1.33.tar.gz}
 :deps [:karate/glibc :karate/libxml2 :karate/zlib]
 :build_deps [:karate/coreutils :karate/patch :karate/make :karate/gcc]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]}
