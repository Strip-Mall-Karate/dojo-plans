;; libcxx, ported from its plan.sh.
{:name :libcxx
 :origin :karate
 :version :5.0.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:NCSA]
 :description "A new implementation of the C++ standard library, targeting C++11"
 :upstream_url "http://libcxx.llvm.org/"
 :source {:url "http://llvm.org/releases/5.0.1/libcxx-5.0.1.src.tar.xz"
          :sha256 :fa8f99dd2bde109daa3276d529851a3bce5718d46ce1c5d0806f46caa3e57c00
          :filename :libcxx-5.0.1.src.tar.xz}
 :deps [:karate/gcc-libs :karate/glibc :karate/libcxxabi]
 :build_deps [:karate/clang
              :karate/cmake
              :karate/gcc
              :karate/llvm
              :karate/make]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :unpack (fn [b]
           (b:mkdir (.. b.cache "/" b.name "-" b.version :/libcxx))
           (b:run [:tar :xf (.. b.cache :/libcxx-5.0.1.src.tar.xz) :--strip :1]
                  {:cwd (.. b.cache "/" b.name "-" b.version :/libcxx)}))
 :prepare (fn [b]
            (b:env :BUILDDIR :_build)
            (b:mkdir (or (b:getenv :BUILDDIR) "")))
 :build (fn [b]
          (local v-llvm-path (b:path_for :karate/llvm))
          (b:run [:cmake
                  (.. :-DCMAKE_INSTALL_PREFIX= b.prefix)
                  (.. :-DLLVM_PATH= v-llvm-path)
                  :-DLIBCXX_CXX_ABI=libcxxabi
                  :../libcxx]
                 {:cwd (or (b:getenv :BUILDDIR) "")})
          (b:run [:make] {:cwd (or (b:getenv :BUILDDIR) "")}))
 :install (fn [b]
            (b:run [:make :install-libcxx] {:cwd (or (b:getenv :BUILDDIR) "")}))}
