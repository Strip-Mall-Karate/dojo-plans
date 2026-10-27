;; zstd, ported from its plan.sh.
{:name :zstd
 :origin :karate
 :version :1.3.8
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:BSD-3-Clause]
 :description "Zstandard is a real-time compression algorithm, providing high compression ratios. It offers a very wide range of compression / speed trade-off, while being backed by a very fast decoder"
 :upstream_url "http://facebook.github.io/zstd/"
 :source {:url "https://github.com/facebook/zstd/archive/v1.3.8.tar.gz"
          :sha256 :90d902a1282cc4e197a8023b6d6e8d331c1fd1dfe60f7f8e4ee9da40da886dc3}
 :deps [:karate/glibc]
 :build_deps [:karate/gcc :karate/make :karate/diffutils]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]
 :build (fn [b]
          (b:run [:make (.. :PREFIX= b.prefix)]))
 :check (fn [b]
          (b:run [:make :test]))}
