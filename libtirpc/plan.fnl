;; libtirpc, ported from its plan.sh.
{:name :libtirpc
 :origin :karate
 :version :1.0.3
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:BSD-3-Clause]
 :description "Libtirpc is a port of Suns Transport-Independent RPC library to Linux."
 :upstream_url "http://libtirpc.sourceforge.net/"
 :source {:url "https://netix.dl.sourceforge.net/project/libtirpc/libtirpc/1.0.3/libtirpc-1.0.3.tar.bz2"
          :sha256 :86c3a78fc1bddefa96111dd233124c703b22a78884203c55c3e06b3be6a0fd5e}
 :deps [:karate/glibc :karate/krb5]
 :build_deps [:karate/diffutils :karate/gcc :karate/make]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]}
