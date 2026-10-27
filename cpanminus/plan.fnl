;; cpanminus, ported from its plan.sh.
{:name :cpanminus
 :origin :karate
 :version :1.7044
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Artistic-2.0]
 :description "cpanminus is a script to get, unpack, build and install modules from CPAN and does nothing else."
 :upstream_url "http://cpanmin.us"
 :source {:url "https://github.com/miyagawa/cpanminus/archive/1.7044.tar.gz"
          :sha256 :a5407a85c2f3dda74dfc2241c68dafb9951f2a6eeada0a0eea9e7238a482c195
          :filename :cpanminus-1.7044.tar.gz
          :dirname :cpanminus-1.7044}
 :deps [:karate/glibc :karate/local-lib :karate/perl]
 :build_deps [:karate/coreutils
              :karate/curl
              :karate/gcc
              :karate/local-lib
              :karate/make
              :karate/perl]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :build (fn [b]
          nil)
 :install (fn [b]
            (each [setting (string.gmatch (b:capture [:perl
                                                      (.. :-I
                                                          (b:path_for :karate/local-lib)
                                                          :/lib/perl5)
                                                      (.. "-Mlocal::lib="
                                                          (b:path_for :karate/local-lib))
                                                      :-e
                                                      "print qq{$_=$ENV{$_}\\n} for qw(PATH PERL5LIB PERL_LOCAL_LIB_ROOT PERL_MB_OPT PERL_MM_OPT)"])
                                          "[^\n]+")]
              (let [(name value) (setting:match "^([^=]+)=(.*)$")]
                (b:env name value)))
            (each [setting (string.gmatch (b:capture [:perl
                                                      (.. "-Mlocal::lib="
                                                          b.prefix)
                                                      :-e
                                                      "print qq{$_=$ENV{$_}\\n} for qw(PATH PERL5LIB PERL_LOCAL_LIB_ROOT PERL_MB_OPT PERL_MM_OPT)"])
                                          "[^\n]+")]
              (let [(name value) (setting:match "^([^=]+)=(.*)$")]
                (b:env name value)))
            ;; The plan piped the live cpanmin.us script into perl, which installed the newest
            ;; App::cpanminus from CPAN. The checksummed source is App::cpanminus at this
            ;; version; with local::lib's settings it installs into the prefix.
            (b:run [:perl :Makefile.PL])
            (b:run [:make :install]))}
