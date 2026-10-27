;; lzop, ported from its plan.sh.
{:name :lzop
 :origin :karate
 :version :1.04
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-2.0]
 :description "lzop is a file compressor which is very similar to gzip. lzop uses the LZO data compression library for compression services, and its main advantages over gzip are much higher compression and decompression speed (at the cost of some compression ratio)."
 :upstream_url "https://www.lzop.org/"
 :source {:url "https://www.lzop.org/download/lzop-1.04.tar.gz"
          :sha256 :7e72b62a8a60aff5200a047eea0773a8fb205caf7acbe1774d95147f305a2f41}
 :deps [:karate/glibc :karate/lzo]
 :build_deps [:karate/make :karate/gcc]
 :bin_dirs [:bin]}
