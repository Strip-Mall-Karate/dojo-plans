;; lsyncd, ported from its plan.sh.
{:name :lsyncd
 :origin :karate
 :version :2.2.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-2.0]
 :description "Lsyncd watches a local directory trees event monitor interface (inotify or fsevents)"
 :upstream_url "https://axkibe.github.io/lsyncd/"
 :source {:url "https://github.com/axkibe/lsyncd/archive/release-2.2.1.tar.gz"
          :sha256 :f41969454a17f9441a9b1809bb251235631768393bf5d29ad8e8142670ae4735
          :dirname :lsyncd-release-2.2.1}
 :deps [:karate/glibc]
 :build_deps [:karate/cmake :karate/gcc :karate/lua :karate/make]
 :bin_dirs [:bin]
 :build (fn [b]
          (b:run [:cmake
                  "-DLUA_LIBRARIES=lua -ldl -lm"
                  (.. :-DLUA_INCLUDE_DIR= (b:path_for :lua) :/include)
                  (.. "-DCMAKE_INSTALL_PREFIX:PATH=" b.prefix)
                  "."])
          (b:run [:make]))}
