;; freetype, ported from its plan.sh.
{:name :freetype
 :origin :karate
 :version :2.9.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:FreeType :GPL-2.0]
 :description "A software library to render fonts"
 :upstream_url "https://www.freetype.org"
 :source {:url "http://download.savannah.gnu.org/releases/freetype/freetype-2.9.1.tar.bz2"
          :sha256 :db8d87ea720ea9d5edc5388fc7a0497bb11ba9fe972245e0f7f4c7e8b1e1e84d
          :filename :freetype-2.9.1.tar.gz}
 :deps [:karate/bzip2 :karate/glibc :karate/libpng :karate/zlib]
 :build_deps [:karate/coreutils
              :karate/diffutils
              :karate/gcc
              :karate/make
              :karate/pkg-config]
 :lib_dirs [:lib]
 :include_dirs [:include]}
