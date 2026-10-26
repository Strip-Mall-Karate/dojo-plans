;; clingo, ported from its plan.sh.
{:name "clingo"
 :origin "karate"
 :version "5.3.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "A grounder and solver for logic programs."
 :upstream_url "https://potassco.org/clingo"
 :source {:url "https://github.com/potassco/clingo/archive/v5.3.0.tar.gz" :sha256 "b0d406d2809352caef7fccf69e8864d55e81ee84f4888b0744894977f703f976"}
 :deps ["karate/gcc-libs" "karate/glibc"]
 :build_deps ["karate/cmake" "karate/doxygen" "karate/gcc" "karate/make"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:mkdir (b:join b.src "build"))
          (b:run ["cmake" "-H./" "-Bbuild" "-DCMAKE_BUILD_TYPE=Release" (.. "-DCMAKE_INSTALL_PREFIX=" (or (b:getenv "PREFIX") "")) "-DCLINGO_MANAGE_RPATH=YES" "-DCLINGO_BUILD_APPS=YES"])
          (b:run ["make" "-C" "build"]))
 :install (fn [b]
          (b:run ["make" "-C" "build" "install"]))}
