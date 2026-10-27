;; libevent, ported from its plan.sh.
{:name :libevent
 :origin :karate
 :version :2.0.22
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:BSD-3-Clause]
 :source {:url "https://github.com/libevent/libevent/releases/download/release-2.0.22-stable/libevent-2.0.22-stable.tar.gz"
          :sha256 :71c2c49f0adadacfdbe6332a372c38cf9c8b7895bb73dabeaa53cdcc1d4e1fa3
          :dirname :libevent-2.0.22-stable}
 :deps [:karate/glibc]
 :build_deps [:karate/cacerts :karate/gcc :karate/make]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]}
