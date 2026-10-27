;; serf, ported from its plan.sh.
{:name :serf
 :origin :karate
 :version :1.3.8
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0]
 :description "A high performance C-based HTTP client library built upon the Apache Portable Runtime (APR) library."
 :upstream_url "https://serf.apache.org/"
 :source {:url "https://archive.apache.org/dist/serf/serf-1.3.8.tar.bz2"
          :sha256 :e0500be065dbbce490449837bb2ab624e46d64fc0b090474d9acaa87c82b2590}
 :deps [:karate/apr
        :karate/apr-util
        :karate/glibc
        :karate/openssl
        :karate/zlib]
 :build_deps [:karate/gcc
              :karate/make
              :karate/patch
              :karate/python2
              :karate/scons]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :prepare (fn [b]
            (b:run [:patch :-i (.. b.plan_dir :/pass-env-to-scons.patch)]))
 :build (fn [b]
          (b:run [:scons
                  (.. :PREFIX= b.prefix)
                  (.. :APR= (b:path_for :apr))
                  (.. :APU= (b:path_for :apr-util))
                  (.. :OPENSSL= (b:path_for :openssl))]))
 :install (fn [b]
            (b:run [:scons :install]))}
