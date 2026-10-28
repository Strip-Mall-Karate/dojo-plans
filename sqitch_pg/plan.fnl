;; sqitch_pg, ported from its plan.sh.
{:name :sqitch_pg
 :origin :karate
 :version :3.7.4
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Artistic-1.0-Perl :GPL-2.0]
 :description "Sqitch the database management application, bundled with the DBD::Pg Perl module for PostgreSQL"
 :upstream_url "http://sqitch.org/"
 :deps [:karate/glibc
        :karate/perl
        :karate/postgresql-client
        :karate/zlib
        :karate/sqitch]
 :build_deps [:karate/cpanminus :karate/local-lib :karate/gcc :karate/make]
 :bin_dirs [:bin]
 :prepare (fn [b]
            ;; From do_setup_environment.
            (b:runtime_env_push :PERL5LIB
                                (.. b.prefix
                                    :/lib/perl5/x86_64-linux-thread-multi))
            (b.default.prepare b))
 :build (fn [_b]
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
                                                      (.. :-I
                                                          (b:path_for :karate/cpanminus)
                                                          :/lib/perl5)
                                                      (.. "-Mlocal::lib="
                                                          (b:path_for :karate/cpanminus))
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
            (b:run [:cpanm (.. "DBD::Pg@" b.version) :--local-lib b.prefix]))}
