;; ocaml, ported from its plan.sh.
{:name "ocaml"
 :origin "karate"
 :version "4.07.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["LGPL-2.0"]
 :description "The OCAML compiler"
 :upstream_url "https://ocaml.org/"
 :source {:url "https://github.com/ocaml/ocaml/archive/4.07.0.tar.gz" :sha256 "8dd39da81beaad53a158e71c428f902b609d8f7f33fedf37f15c56be6c4cf840"}
 :deps ["karate/glibc"]
 :build_deps ["karate/make" "karate/gcc"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :build (fn [b]
          (b:run ["./configure" "--prefix" b.prefix "-no-graph"])
          (b:run ["make" "world.opt"]))
 :check (fn [b]
          (b:run ["make" "bootstrap"]))
 :strip (fn [b]
          nil)}
