;; mono5, ported from its plan.sh.
{:name :mono5
 :origin :karate
 :version :5.10.1.47
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Microsoft-Patent-Promise-for-Mono]
 :description "Mono 5.x open source ECMA CLI, C# and .NET implementation."
 :upstream_url "https://www.mono-project.com"
 :source {:url "https://download.mono-project.com/sources/mono/mono-5.10.1.47.tar.bz2"
          :sha256 :90c237b5288f95f6fdab4ace1e36ab64a6369e2c9fddd462d604fd788e2545da
          :filename :mono-5.10.1.47.tar.bz2
          :dirname :mono-5.10.1.47}
 :deps [:karate/gcc-libs :karate/glibc :karate/tzdata :karate/zlib]
 :build_deps [:karate/cmake
              :karate/diffutils
              :karate/gcc
              :karate/gettext
              :karate/libtool
              :karate/make
              :karate/ncurses
              :karate/perl
              :karate/pkg-config
              :karate/python
              :karate/tzdata
              :karate/which]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]
 :prepare (fn [b]
            (var v-with-gnu-ld "")
            (b:env :with_gnu_ld :yes))}
