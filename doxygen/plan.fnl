;; doxygen, ported from its plan.sh.
;; doxygen 1.18.0, the latest release on 2026-10-26: 1.8.15's source no longer downloads.
{:name :doxygen
 :origin :karate
 :version :1.18.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-2.0]
 :description "Generate documentation for several programming languages"
 :upstream_url "http://www.doxygen.nl/"
 :source {:url "https://www.doxygen.nl/files/doxygen-1.18.0.src.tar.gz"
          :sha256 :a1deed70a6785bbec95a2b2a9e419dc7f7b223a9d74a8644ae611c8e2dcdd354
          :filename :doxygen-1.18.0.src.tar.gz}
 :deps [:karate/gcc-libs :karate/glibc :karate/libiconv]
 :build_deps [:karate/bison
              :karate/cmake
              :karate/diffutils
              :karate/flex
              :karate/gcc
              :karate/libxml2
              :karate/m4
              :karate/make
              :karate/python2]
 :bin_dirs [:bin]
 :build (fn [b]
          (b:mkdir (b:join b.src :build))
          (b:log "Setting libiconv flags...")
          (b:env :CXXFLAGS (.. "-liconv " (or (b:getenv :CXXFLAGS) "")))
          (b:log (.. "CXXFLAGS are now: " (or (b:getenv :CXXFLAGS) "")))
          (b:run [:cmake
                  (.. "-DCMAKE_INSTALL_PREFIX:PATH=" b.prefix)
                  (.. :-DICONV_INCLUDE_DIR= (b:path_for :karate/libiconv)
                      :/include)
                  :-G
                  "Unix Makefiles"
                  "../"] {:cwd :build})
          (b:run [:make] {:cwd :build}))
 :install (fn [b]
            (b:run [:make :install] {:cwd :build}))}
