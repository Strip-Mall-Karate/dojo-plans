;; ocamlbuild, ported from its plan.sh.
{:name :ocamlbuild
 :origin :karate
 :version :0.11.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:LGPL]
 :description "OCamlbuild is a generic build tool, that has built-in rules for building OCaml library and programs."
 :upstream_url "https://github.com/ocaml/ocamlbuild"
 :source {:url "https://github.com/ocaml/ocamlbuild/archive/0.11.0.tar.gz"
          :sha256 :1717edc841c9b98072e410f1b0bc8b84444b4b35ed3b4949ce2bec17c60103ee}
 :deps [:karate/glibc :karate/ocaml :karate/coreutils :karate/ncurses]
 :build_deps [:karate/gcc :karate/make]
 :bin_dirs [:bin]
 :build (fn [b]
          (b:run [:make
                  :configure
                  (.. :OCAMLBUILD_PREFIX= b.prefix)
                  (.. :OCAMLBUILD_BINDIR= b.prefix :/bin)
                  (.. :OCAMLBUILD_LIBDIR= b.prefix :/lib)])
          (b:run [:make]))}
