;; git, ported from its plan.sh.
{:name "git"
 :origin "karate"
 :version "2.21.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0"]
 :description "Git is a free and open source distributed version control\nsystem designed to handle everything from small to very large projects with\nspeed and efficiency."
 :upstream_url "https://git-scm.com/"
 :source {:url "https://www.kernel.org/pub/software/scm/git/git-2.21.0.tar.gz" :sha256 "85eca51c7404da75e353eba587f87fea9481ba41e162206a6f70ad8118147bee" :filename "git-2.21.0.tar.gz"}
 :deps ["karate/cacerts" "karate/curl" "karate/expat" "karate/gettext" "karate/gcc-libs" "karate/glibc" "karate/openssh" "karate/perl" "karate/sed" "karate/zlib"]
 :build_deps ["karate/make" "karate/gcc"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :prepare (fn [b]
          (var v-perl-path "")
          (set v-perl-path (.. (b:path_for "perl") "/bin/perl"))
          (let [text (b:read (b:join b.src "Makefile"))] (b:write (b:join b.src "Makefile") (pick-values 1 (string.gsub text "[^\n]+" (fn [l] (var line l) (set line (pick-values 1 (string.gsub line "/usr/bin/perl" (pick-values 1 (: v-perl-path :gsub "%%" "%%%%"))))) line))))))}
