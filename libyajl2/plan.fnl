;; libyajl2, ported from its plan.sh.
;; libyajl2 2.1.0, the latest release on 2026-10-26: the old archive URL became ambiguous (a branch and a tag share the name), so it names the tag.
{:name :libyajl2
 :origin :karate
 :version :2.1.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:ISC]
 :description "Yet Another JSON Library"
 :upstream_url "https://github.com/lloyd/yajl"
 :source {:url "https://github.com/lloyd/yajl/archive/refs/tags/2.1.0.tar.gz"
          :sha256 :3fb73364a5a30efe615046d07e6db9d09fd2b41c763c5f7d3bfb121cd5c5ac5a
          :filename :libyajl2-2.1.0.tar.gz
          :dirname :yajl-2.1.0}
 :deps [:karate/glibc]
 :build_deps [:karate/busybox-static
              :karate/cmake
              :karate/doxygen
              :karate/gcc
              :karate/make]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :pconfig_dirs [:share/pkgconfig]
 :install (fn [b]
            (each [_ v-type (ipairs [:bin :include :lib :share])]
              (if (b:exists b.prefix)
                  (b:copy (.. b.src :/build/yajl- b.version "/" v-type)
                          (b:join b.prefix
                                  (: (.. b.src :/build/yajl- b.version "/"
                                         v-type)
                                     :match "[^/]+$")))
                  (b:copy (.. b.src :/build/yajl- b.version "/" v-type)
                          b.prefix))))}
