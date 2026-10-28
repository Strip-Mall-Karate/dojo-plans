;; camlp4, ported from its plan.sh.
{:name :camlp4
 :origin :karate
 :version :4.07
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:LGPL-2.0]
 :description "Camlp4 is a software system for writing extensible parsers for programming languages. It provides a set of OCaml libraries that are used to define grammars as well as loadable syntax extensions of such grammars."
 :upstream_url "https://github.com/ocaml/camlp4"
 :source {:url "https://github.com/ocaml/camlp4/archive/4.07+1.tar.gz"
          :sha256 :ecdb8963063f41b387412317685f79823a26b3f53744f0472058991876877090
          :dirname :camlp4-4.07-1}
 :deps [:karate/coreutils :karate/glibc :karate/ocaml]
 :build_deps [:karate/gcc :karate/make :karate/ocamlbuild :karate/which]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :build (fn [b]
          (b:run [:./configure
                  (.. :--bindir= b.prefix :/bin)
                  (.. :--libdir= b.prefix :/lib)
                  (.. :--pkgdir= b.prefix)])
          (b:run [:make :all]))
 :strip (fn [_b]
          nil)}
