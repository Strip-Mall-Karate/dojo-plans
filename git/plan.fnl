;; git, ported from its plan.sh.
;; git 2.56.0, the latest release on 2026-10-27: 2.21.0 does not build against curl 8. Its build
;; compiles some of git in Rust with cargo.
{:name "git"
 :origin "karate"
 :version "2.56.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0"]
 :description "Git is a free and open source distributed version control\nsystem designed to handle everything from small to very large projects with\nspeed and efficiency."
 :upstream_url "https://git-scm.com/"
 :source {:url "https://www.kernel.org/pub/software/scm/git/git-2.56.0.tar.xz" :sha256 "26c56c296b38c0695b26fa95f475f1d01704d2d38e73465ca30b0b2f5dc789d3"}
 :deps ["karate/cacerts" "karate/curl" "karate/expat" "karate/gettext" "karate/gcc-libs" "karate/glibc" "karate/openssh" "karate/perl" "karate/sed" "karate/zlib"]
 :build_deps ["karate/make" "karate/gcc" "karate/rust"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :prepare (fn [b]
          (var v-perl-path "")
          (set v-perl-path (.. (b:path_for "perl") "/bin/perl"))
          (let [text (b:read (b:join b.src "Makefile")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line "/usr/bin/perl" (pick-values 1 (: v-perl-path :gsub "%%" "%%%%"))))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join b.src "Makefile") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" "")))))}
