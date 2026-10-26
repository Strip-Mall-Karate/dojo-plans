;; snappy, ported from its plan.sh.
{:name "snappy"
 :origin "karate"
 :version "1.1.4"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["BSD-3-Clause"]
 :description "A fast compressor/decompressor http://google.github.io/snappy/"
 :upstream_url "https://github.com/google/snappy"
 :source {:url "https://github.com/google/snappy/releases/download/1.1.4/snappy-1.1.4.tar.gz" :sha256 "134bfe122fd25599bb807bb8130e7ba6d9bdb851e0b16efcb83ac4f5d0b70057"}
 :deps ["karate/glibc"]
 :build_deps ["karate/gcc" "karate/make" "karate/autoconf" "karate/automake" "karate/pkg-config" "karate/libtool" "karate/m4" "karate/sed" "karate/pkg-config"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["libtoolize" "--force"])
          (b:run ["autoreconf" "-iv"] {:env {"ACLOCAL_PATH" (.. (b:path_for "karate/pkg-config") "/share/aclocal")}})
          (b:run ["./configure" (.. "--prefix=" b.prefix)])
          (b:run ["make"]))
 :check (fn [b]
          (b:run ["make" "check"]))}
