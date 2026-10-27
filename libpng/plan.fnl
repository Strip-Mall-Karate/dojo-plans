;; libpng, ported from its plan.sh.
{:name :libpng
 :origin :karate
 :version :1.6.36
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:libpng]
 :description "An Open, Extensible Image Format with Lossless Compression"
 :upstream_url "http://www.libpng.org/pub/png/"
 :source {:url "http://download.sourceforge.net/libpng/libpng-1.6.36.tar.gz"
          :sha256 :ca13c548bde5fb6ff7117cc0bdab38808acb699c0eccb613f0e4697826e1fd7d
          :filename :libpng-1.6.36.tar.gz}
 :deps [:karate/glibc :karate/zlib]
 :build_deps [:karate/gcc
              :karate/make
              :karate/coreutils
              :karate/diffutils
              :karate/autoconf
              :karate/automake]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :build (fn [b]
          (var v--zlib-dir "")
          (set v--zlib-dir (b:path_for :zlib))
          (b:run [:./configure
                  (.. :--prefix= b.prefix)
                  :--host=x86_64-unknown-linux-gnu
                  :--build=x86_64-unknown-linux-gnu
                  :--disable-static
                  (.. :--with-zlib-prefix= v--zlib-dir)])
          (b:run [:make]))
 :check (fn [b]
          (b:run [:make :test]))}
