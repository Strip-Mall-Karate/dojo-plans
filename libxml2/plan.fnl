;; libxml2, ported from its plan.sh.
{:name :libxml2
 :origin :karate
 :version :2.9.9
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "Libxml2 is the XML C parser and toolkit developed for the Gnome project"
 :upstream_url "http://xmlsoft.org/"
 :source {:url "http://xmlsoft.org/sources/libxml2-2.9.9.tar.gz"
          :sha256 :94fb70890143e3c6549f265cee93ec064c80a84c42ad0f23e85ee1fd6540a871
          :filename :libxml2-2.9.9.tar.xz}
 :deps [:karate/zlib :karate/glibc]
 :build_deps [:karate/coreutils :karate/make :karate/gcc :karate/m4]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :build (fn [b]
          (b:run [:./configure
                  (.. :--prefix= b.prefix)
                  :--without-python
                  (.. :--with-zlib= (b:path_for :zlib))])
          (b:run [:make]))}
