;; gifsicle, ported from its plan.sh.
{:name :gifsicle
 :origin :karate
 :version :1.91
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPLv2]
 :description "Gifsicle is a command-line tool for creating, editing, and getting information about GIF images and animations."
 :upstream_url "https://www.lcdf.org/gifsicle/"
 :source {:url "https://www.lcdf.org/gifsicle/gifsicle-1.91.tar.gz"
          :sha256 :0a4ee602aa244cdcdd86a250a6b39c94d8343cf526b8fae862d8a0efc337a800}
 :deps [:karate/zlib :karate/glibc]
 :build_deps [:karate/zlib
              :karate/coreutils
              :karate/diffutils
              :karate/patch
              :karate/make
              :karate/gcc
              :karate/sed
              :karate/glibc]
 :bin_dirs [:bin]}
