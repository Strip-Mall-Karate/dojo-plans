;; papi, ported from its plan.sh.
{:name "papi"
 :origin "karate"
 :version "5.6.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["BSD-3-Clause"]
 :description "Performance API"
 :upstream_url "http://icl.cs.utk.edu/papi/"
 :source {:url "http://icl.utk.edu/projects/papi/downloads/papi-5.6.0.tar.gz" :sha256 "49b7293f9ca2d74d6d80bd06b5c4be303663123267b4ac0884cbcae4c914dc47"}
 :deps ["karate/glibc"]
 :build_deps ["karate/gcc" "karate/linux-headers" "karate/make" "karate/pkg-config"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :prepare (fn [b]
          (var v-library-path (.. (b:path_for "karate/glibc") "/lib")))
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix)] {:cwd "src"})
          (b:run ["make"] {:cwd "src"}))
 :install (fn [b]
          (b:run ["make" "install"] {:cwd "src"}))}
