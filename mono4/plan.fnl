;; mono4, ported from its plan.sh.
{:name :mono4
 :origin :karate
 :version :4.8.1.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Microsoft-Patent-Promise-for-Mono]
 :description "Mono 4.x open source ECMA CLI, C# and .NET implementation."
 :upstream_url "https://www.mono-project.com"
 :source {:url "https://download.mono-project.com/sources/mono/mono-4.8.1.0.tar.bz2"
          :sha256 :18cb38a670e51609c36c687ed90ad42cfedabeffd0a2dc5f7f0c46249eb8dbef
          :filename :mono-4.8.1.0.tar.bz2
          :dirname :mono-4.8.1}
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
              :karate/python]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]
 :prepare (fn [b]
            (var v-with-gnu-ld "")
            (b:env :with_gnu_ld :yes))}
