;; sqitch, ported from its plan.sh.
{:name "sqitch"
 :origin "karate"
 :version "0.9994"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "Sqitch is a database change management application."
 :upstream_url "http://sqitch.org/"
 :source {:url "https://cpan.metacpan.org/authors/id/D/DW/DWHEELER/App-Sqitch-0.9994.tar.gz" :sha256 "24de7770884419f199d24fa2ce81f5e7a27583028f685e6973a06840be00c646" :filename "App-Sqitch-0.9994.tar.gz" :dirname "App-Sqitch-0.9994"}
 :deps ["karate/glibc" "karate/perl" "karate/local-lib" "karate/cpanminus"]
 :build_deps ["karate/gcc" "karate/make" "karate/coreutils" "karate/perl" "karate/local-lib" "karate/cpanminus"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :prepare (fn [b]
          ;; From do_setup_environment.
          (b:runtime_env_push "PERL5LIB" (.. b.prefix "/lib/perl5:" b.prefix "/lib/perl5/x86_64-linux-thread-multi"))
          (each [setting (string.gmatch (b:capture ["perl" (.. "-I" (b:path_for "karate/local-lib") "/lib/perl5") (.. "-Mlocal::lib=" (b:path_for "karate/local-lib")) "-e" "print qq{$_=$ENV{$_}\\n} for qw(PATH PERL5LIB PERL_LOCAL_LIB_ROOT PERL_MB_OPT PERL_MM_OPT)"]) "[^\n]+")]
            (let [(name value) (setting:match "^([^=]+)=(.*)$")] (b:env name value)))
          (each [setting (string.gmatch (b:capture ["perl" (.. "-Mlocal::lib=" b.prefix) "-e" "print qq{$_=$ENV{$_}\\n} for qw(PATH PERL5LIB PERL_LOCAL_LIB_ROOT PERL_MB_OPT PERL_MM_OPT)"]) "[^\n]+")]
            (let [(name value) (setting:match "^([^=]+)=(.*)$")] (b:env name value)))
          (b:run ["cpanm" "Module::Build"]))
 :build (fn [b]
          (b:run ["perl" "Build.PL"]))
 :check (fn [b]
          (b:run ["./Build" "test"]))
 :install (fn [b]
          (b:env "PERL_MM_USE_DEFAULT" "1")
          (b:run ["./Build" "installdeps" "--cpan_client" "cpanm -v --notest" "--defaultdeps"])
          (b:run ["./Build"])
          (b:run ["./Build" "install"])
          (each [_ v-file (ipairs (b:glob (.. b.prefix "/bin") "*"))]
            (let [text (b:read v-file) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (when (= n 1) (set line (pick-values 1 (string.gsub line ".*" (.. "%0 -I" (pick-values 1 (: b.prefix :gsub "%%" "%%%%")) "/lib/perl5") 1)))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write v-file (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" ""))))))}
