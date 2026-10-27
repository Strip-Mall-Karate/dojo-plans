;; aspcud, ported from its plan.sh.
{:name :aspcud
 :origin :karate
 :version :1.9.4
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-3.0]
 :description "Aspcud is a solver for package dependencies"
 :upstream_url "https://potassco.org/aspcud/"
 :source {:url "https://github.com/potassco/aspcud/archive/v1.9.4.tar.gz"
          :sha256 :3645f08b079e1cc80e24cd2d7ae5172a52476d84e3ec5e6a6c0034492a6ea885}
 :deps [:karate/clingo :karate/gcc-libs :karate/glibc]
 :build_deps [:karate/boost
              :karate/cmake
              :karate/make
              :karate/gcc
              :karate/re2c]
 :bin_dirs [:bin]
 :build (fn [b]
          (b:mkdir (b:join b.src :build))
          (b:run [:cmake
                  :-H./
                  :-Bbuild
                  (.. :-DBOOST_INCLUDEDIR= (b:path_for :boost) :/include)
                  :-DCMAKE_BUILD_TYPE=Release
                  (.. :-DCMAKE_INSTALL_PREFIX= b.prefix)
                  (.. :-DASPCUD_GRINGO_PATH= (b:path_for :clingo) :/bin/gringo)
                  (.. :-DASPCUD_CLASP_PATH= (b:path_for :clingo) :/bin/clasp)])
          (b:run [:make :-C :build]))
 :install (fn [b]
            (b:run [:make :-C :build :install]))}
