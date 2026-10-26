;; mksh, ported from its plan.sh.
{:name "mksh"
 :origin "karate"
 :version "R56c"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MirOS" "ISC" "BSD-3-Clause"]
 :description "The MirBSD Korn Shell"
 :upstream_url "http://www.mirbsd.org/mksh.htm"
 :source {:url "https://www.mirbsd.org/MirOS/dist/mir/mksh/mksh-R56c.tgz" :sha256 "dd86ebc421215a7b44095dc13b056921ba81e61b9f6f4cdab08ca135d02afb77" :dirname "mksh"}
 :deps ["karate/glibc"]
 :build_deps ["karate/make" "karate/gcc" "karate/gawk" "karate/wget"]
 :bin_dirs ["bin"]
 :interpreters ["bin/ksh" "bin/mksh"]
 :build (fn [b]
          (b:run ["sh" "Build.sh" "-r"]))
 :install (fn [b]
          (b:copy (b:join b.src "mksh") (.. b.prefix "/bin/mksh"))
          (b:chmod (.. b.prefix "/bin/mksh") "755")
          (let [link (if (b:exists (b:join (b:join (.. b.prefix "/bin") "ksh") ".")) (b:join (b:join (.. b.prefix "/bin") "ksh") "mksh") (b:join (.. b.prefix "/bin") "ksh"))]
            (b:symlink "mksh" link))
          (b:mkdir (.. b.prefix "/share"))
          (b:run ["wget" "https://www.mirbsd.org/TaC-mksh.txt" "-O" (.. b.prefix "/share/TaC-mksh.txt")]))}
