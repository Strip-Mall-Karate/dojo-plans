;; boost, ported from its plan.sh.
{:name "boost"
 :origin "karate"
 :version "1.69.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Boost Software License"]
 :description "Boost provides free peer-reviewed portable C++ source libraries."
 :upstream_url "http://www.boost.org/"
 :source {:url "http://downloads.sourceforge.net/project/boost/boost/1.69.0/boost_1_69_0.tar.gz" :sha256 "9a2c2819310839ea373f42d69e733c339b4e9a19deab6bfec448281554aa4dbb" :dirname "boost_1_69_0"}
 :deps ["karate/glibc" "karate/gcc-libs" "karate/zlib"]
 :build_deps ["karate/glibc" "karate/gcc-libs" "karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/python2" "karate/libxml2" "karate/libxslt" "karate/openssl" "karate/which"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["./bootstrap.sh" (.. "--prefix=" b.prefix)]))
 :install (fn [b]
          (b:env "NO_BZIP2" "1")
          (b:env "ZLIB_LIBPATH" (.. (b:path_for "karate/zlib") "/lib"))
          (b:env "ZLIB_INCLUDE" (.. (b:path_for "karate/zlib") "/include"))
          (b:run ["./b2" "install" (.. "--prefix=" b.prefix) "-q" "--debug-configuration"]))}
