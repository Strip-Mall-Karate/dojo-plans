;; opam, ported from its plan.sh.
{:name "opam"
 :origin "karate"
 :version "1.2.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["LGPL"]
 :description "opam is a source-based package manager. It supports multiple simultaneous compiler installations, flexible package constraints, and a Git-friendly development workflow."
 :upstream_url "https://opam.ocaml.org/"
 :source {:url "https://github.com/ocaml/opam/releases/download/1.2.2/opam-full-1.2.2.tar.gz" :sha256 "15e617179251041f4bf3910257bbb8398db987d863dd3cfc288bdd958de58f00" :dirname "opam-full-1.2.2"}
 :deps ["karate/aspcud" "karate/camlp4" "karate/diffutils" "karate/gcc" "karate/git" "karate/glibc" "karate/m4" "karate/make" "karate/patch" "karate/pkg-config" "karate/rsync" "karate/ocaml" "karate/ocamlbuild" "karate/which"]
 :bin_dirs ["bin"]
 :build (fn [b]
          (b:run ["./configure" "--prefix" b.prefix])
          (b:run ["make" "lib-ext"])
          (b:run ["make"]))
 :strip (fn [b]
          nil)}
