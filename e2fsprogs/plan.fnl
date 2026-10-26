;; e2fsprogs, ported from its plan.sh.
{:name "e2fsprogs"
 :origin "karate"
 :version "1.44.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0"]
 :description "Ext2/3/4 filesystem userspace utilities"
 :upstream_url "http://e2fsprogs.sourceforge.net/"
 :source {:url "https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git/snapshot/e2fsprogs-1.44.1.tar.gz" :sha256 "1531c91198520d6868d1106b6b508c5fc780533952f63c2dfd2afec282aa7097"}
 :deps ["karate/glibc"]
 :build_deps ["karate/make" "karate/gcc"]
 :bin_dirs ["bin" "sbin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]}
