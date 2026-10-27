;; libcxxabi, ported from its plan.sh.
{:name :libcxxabi
 :origin :karate
 :version :5.0.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:NCSA]
 :description "A new implementation of the C++ standard library, targeting C++11"
 :upstream_url "http://libcxxabi.llvm.org/"
 :source {:url "http://llvm.org/releases/5.0.1/libcxxabi-5.0.1.src.tar.xz"
          :sha256 :5a25152cb7f21e3c223ad36a1022faeb8a5ac27c9e75936a5ae2d3ac48f6e854
          :filename :libcxxabi-5.0.1.src.tar.xz}
 :deps [:karate/gcc-libs :karate/glibc]
 :build_deps [:karate/clang
              :karate/cmake
              :karate/gcc
              :karate/llvm
              :karate/make]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :download (fn [b]
             (b.default.download b)
             (b:log "Downloading libcxx source")
             (b:download (.. "http://llvm.org/releases/" b.version :/libcxx-
                             b.version :.src.tar.xz)
                         :5a25152cb7f21e3c223ad36a1022faeb8a5ac27c9e75936a5ae2d3ac48f6e854
                         (.. :libcxx- b.version :.src.tar.xz)))
 :unpack (fn [b]
           (b:mkdir (.. b.cache "/" (.. b.name "-" b.version) :/libcxx))
           (b:run [:tar
                   :xf
                   (.. b.cache :/libcxx- b.version :.src.tar.xz)
                   :--strip
                   :1]
                  {:cwd (.. b.cache "/" (.. b.name "-" b.version) :/libcxx)})
           (b:mkdir (.. b.cache "/" (.. b.name "-" b.version) :/libcxxabi))
           (b:run [:tar
                   :xf
                   (.. b.cache :/libcxxabi- b.version :.src.tar.xz)
                   :--strip
                   :1]
                  {:cwd (.. b.cache "/" (.. b.name "-" b.version) :/libcxxabi)}))
 :prepare (fn [b]
            (b:env :BUILDDIR :_build)
            (b:mkdir (or (b:getenv :BUILDDIR) "")))
 :build (fn [b]
          (b:run [:cmake
                  (.. :-DCMAKE_INSTALL_PREFIX= b.prefix)
                  (.. :-DCMAKE_CXX_FLAGS= (or (b:getenv :CXXFLAGS) ""))
                  (.. :-DCMAKE_C_FLAGS= (or (b:getenv :CFLAGS) ""))
                  :-DLIBCXXABI_LIBCXX_PATH=../libcxx
                  :../libcxxabi]
                 {:cwd (or (b:getenv :BUILDDIR) "")})
          (b:run [:make] {:cwd (or (b:getenv :BUILDDIR) "")}))
 :check (fn [b]
          (b:run [:make :check-libcxxabi] {:cwd (or (b:getenv :BUILDDIR) "")}))
 :install (fn [b]
            (b:run [:make :install-libcxxabi]
                   {:cwd (or (b:getenv :BUILDDIR) "")})
            (b:copy (b:join (or (b:getenv :BUILDDIR) "")
                            :../libcxxabi/include/cxxabi.h)
                    (.. b.prefix :/include/cxxabi.h))
            (b:chmod (.. b.prefix :/include/cxxabi.h) :644)
            (b:copy (b:join (or (b:getenv :BUILDDIR) "")
                            :../libcxxabi/include/__cxxabi_config.h)
                    (.. b.prefix :/include/__cxxabi_config.h))
            (b:chmod (.. b.prefix :/include/__cxxabi_config.h) :644))}
