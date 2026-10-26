;; boost159, ported from its plan.sh.
{:name "boost159"
 :origin "karate"
 :version "1.59.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Boost Software License"]
 :description "Boost provides free peer-reviewed portable C++ source libraries."
 :upstream_url "http://www.boost.org/"
 :source {:url "http://downloads.sourceforge.net/project/boost/boost/1.59.0/boost_1_59_0.tar.gz" :sha256 "47f11c8844e579d02691a607fbd32540104a9ac7a2534a8ddaef50daf502baac" :dirname "boost_1_59_0"}
 :deps ["karate/glibc" "karate/gcc-libs" "karate/zlib"]
 :build_deps ["karate/glibc" "karate/gcc-libs" "karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/python2" "karate/libxml2" "karate/libxslt" "karate/openssl" "karate/which"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["./bootstrap.sh" (.. "--prefix=" b.prefix)]))
 :install (fn [b]
          (b:env "NO_BZIP2" "1")
          (var v-zlib-libpath (.. (b:path_for "karate/zlib") "/lib"))
          (var v-zlib-include (.. (b:path_for "karate/zlib") "/include"))
          (b:run ["./b2" "install" (.. "--prefix=" b.prefix) "-q" "--debug-configuration" (.. "-j" (tostring b.jobs))]))}
