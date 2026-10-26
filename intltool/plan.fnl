;; intltool, ported from its plan.sh.
{:name "intltool"
 :origin "karate"
 :version "0.51.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPLv2"]
 :description "intltool is a set of tools to centralize translation of many different file formats using GNU gettext-compatible PO files."
 :upstream_url "https://freedesktop.org/wiki/Software/intltool/"
 :source {:url "https://launchpad.net/intltool/trunk/0.51.0/+download/intltool-0.51.0.tar.gz" :sha256 "67c74d94196b153b774ab9f89b2fa6c6ba79352407037c8c14d5aeb334e959cd"}
 :deps ["karate/glibc"]
 :build_deps ["karate/make" "karate/gcc" "karate/patch" "karate/perl" "karate/local-lib" "karate/cpanminus" "karate/expat"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :prepare (fn [b]
          (each [setting (string.gmatch (b:capture ["perl" (.. "-I" (b:path_for "karate/local-lib") "/lib/perl5") (.. "-Mlocal::lib=" (b:path_for "karate/local-lib")) "-e" "print qq{$_=$ENV{$_}\\n} for qw(PATH PERL5LIB PERL_LOCAL_LIB_ROOT PERL_MB_OPT PERL_MM_OPT)"]) "[^\n]+")]
            (let [(name value) (setting:match "^([^=]+)=(.*)$")] (b:env name value)))
          (each [setting (string.gmatch (b:capture ["perl" (.. "-Mlocal::lib=" b.prefix "/lib") "-e" "print qq{$_=$ENV{$_}\\n} for qw(PATH PERL5LIB PERL_LOCAL_LIB_ROOT PERL_MB_OPT PERL_MM_OPT)"]) "[^\n]+")]
            (let [(name value) (setting:match "^([^=]+)=(.*)$")] (b:env name value)))
          (b:run ["cpanm" "XML::Parser" (.. "--configure-args=EXPATLIBPATH=" (b:path_for "karate/expat") "/lib export EXPATINCPATH=" (b:path_for "karate/expat") "/include")])
          (b:run ["patch" "intltool-update.in" (.. b.plan_dir "/intltool-0.51.0-perl-5.26.patch")]))
 :install (fn [b]
          (b.default.install b))}
