;; zsh, ported from its plan.sh.
{:name "zsh"
 :origin "karate"
 :version "5.6.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["zsh"]
 :description "Zsh is a shell designed for interactive use, although it is also a powerful scripting language."
 :upstream_url "http://www.zsh.org"
 :source {:url "https://downloads.sourceforge.net/project/zsh/zsh/5.6.2/zsh-5.6.2.tar.xz" :sha256 "a50bd66c0557e8eca3b8fa24e85d0de533e775d7a22df042da90488623752e9e"}
 :deps ["karate/coreutils" "karate/gdbm" "karate/glibc" "karate/pcre" "karate/ncurses" "karate/perl" "karate/readline"]
 :build_deps ["karate/busybox-static" "karate/gcc" "karate/make"]
 :bin_dirs ["bin"]
 :interpreters ["bin/zsh"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--enable-multibyte" "--enable-cap" "--enable-pcre" (.. "--enable-etcdir=" b.prefix "/etc") "--enable-zsh-secure-free"])
          (b:run ["make"]))
 :check (fn [b]
          (b:run ["make" "check"]))
 :install (fn [b]
          (b:run ["make" "install"])
          (b:mkdir (.. b.prefix "/etc"))
          (if (b:exists (.. b.prefix "/etc"))
            (b:copy (.. b.plan_dir "/zprofile") (b:join (.. b.prefix "/etc") (: (.. b.plan_dir "/zprofile") :match "[^/]+$")))
            (b:copy (.. b.plan_dir "/zprofile") (.. b.prefix "/etc"))))}
