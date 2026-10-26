;; libnl, ported from its plan.sh.
{:name "libnl"
 :origin "karate"
 :version "3.2.25"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["LGPL-2.1-only"]
 :description "The libnl suite is a collection of libraries providing APIs to netlink protocol based Linux kernel interfaces."
 :upstream_url "https://www.infradead.org/~tgr/libnl/"
 :source {:url "https://www.infradead.org/~tgr/libnl/files/libnl-3.2.25.tar.gz" :sha256 "8beb7590674957b931de6b7f81c530b85dc7c1ad8fbda015398bc1e8d1ce8ec5"}
 :deps ["karate/glibc"]
 :build_deps ["karate/make" "karate/gcc" "karate/bison" "karate/flex" "karate/m4"]
 :bin_dirs ["sbin"]
 :lib_dirs ["lib"]
 :include_dirs ["include/libnl3"]
 :pconfig_dirs ["lib/pkgconfig"]
 :check (fn [b]
          (b:run ["make" "test"]))
 :install (fn [b]
          (b.default.install b)
          (b:copy (b:join b.src "COPYING") (b:join (.. b.prefix "/") (: (b:join b.src "COPYING") :match "[^/]+$"))))}
