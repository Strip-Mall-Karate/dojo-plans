;; local-lib, ported from its plan.sh.
{:name :local-lib
 :origin :karate
 :version :2.000019
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Artistic-2.0]
 :description "create and use a local lib/ for perl modules with PERL5LIB"
 :upstream_url "https://github.com/Perl-Toolchain-Gang/local-lib"
 :source {:url "http://search.cpan.org/CPAN/authors/id/H/HA/HAARG/local-lib-2.000019.tar.gz"
          :sha256 :36ad327a099667b8cb292c10229c33849c787470e0b978e4963b69b6df4c0b01
          :filename :local-lib-2.000019.tar.gz
          :dirname :local-lib-2.000019}
 :deps [:karate/glibc :karate/perl]
 :build_deps [:karate/gcc :karate/make :karate/coreutils :karate/perl]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :build (fn [b]
          (b:run [:perl
                  :Makefile.PL
                  (.. :--bootstrap= b.prefix)
                  :--no-manpages]))}
