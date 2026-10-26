;; flex, ported from its plan.sh.
{:name "flex"
 :origin "karate"
 :version "2.6.4"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["custom"]
 :description "Flex is a fast lexical analyser generator. It is a tool for generating programs that perform pattern-matching on text. Flex is a free (but non-GNU) implementation of the original Unix lex program."
 :upstream_url "https://www.gnu.org/software/flex/"
 :source {:url "https://github.com/westes/flex/releases/download/v2.6.4/flex-2.6.4.tar.gz" :sha256 "e87aae032bf07c26f85ac0ed3250998c37621d95f8bd748b31f15b33c45ee995"}
 :deps ["karate/glibc"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/m4" "karate/bison"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :prepare (fn [b]
          (b:env "CFLAGS" (.. (or (b:getenv "CFLAGS") "") " -D_GNU_SOURCE"))
          (b:log (.. "Updating CFLAGS=" (or (b:getenv "CFLAGS") ""))))
 :build (fn [b]
          (b:env "CFLAGS" (.. (or (b:getenv "CFLAGS") "") " -D_GNU_SOURCE"))
          (b.default.build b))
 :check (fn [b]
          (b:run ["make" "check" (.. "LDFLAGS=" (or (b:getenv "LDFLAGS") "") " -lstdc++")]))
 :install (fn [b]
          (b.default.install b)
          (let [link (if (b:exists (b:join (.. b.prefix "/bin/lex") ".")) (b:join (.. b.prefix "/bin/lex") "flex") (.. b.prefix "/bin/lex"))]
            (b:symlink "flex" link)))}
