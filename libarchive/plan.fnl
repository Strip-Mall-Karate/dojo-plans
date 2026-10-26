;; libarchive, ported from its plan.sh.
{:name "libarchive"
 :origin "karate"
 :version "3.3.3"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["BSD"]
 :description "Multi-format archive and compression library"
 :upstream_url "https://www.libarchive.org"
 :source {:url "http://www.libarchive.org/downloads/libarchive-3.3.3.tar.gz" :sha256 "ba7eb1781c9fbbae178c4c6bad1c6eb08edab9a1496c64833d1715d022b30e2e" :dirname "libarchive-3.3.3"}
 :deps ["karate/glibc" "karate/openssl" "karate/zlib" "karate/bzip2" "karate/xz"]
 :build_deps ["karate/gcc" "karate/coreutils" "karate/make"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--without-xml2" "--without-lzo2"] {:env {"CFLAGS" (.. (or (b:getenv "CFLAGS") "") " -fPIC")}})
          (b:run ["make"]))
 :check (fn [b]
          (b:run ["make" "check"]))}
