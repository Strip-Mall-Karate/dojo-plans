;; clang-tools-extra, ported from its plan.sh.
{:name "clang-tools-extra"
 :origin "karate"
 :version "7.0.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["NCSA"]
 :description "Clang Tools are standalone command line (and potentially GUI) tools designed for use by C++ developers who are already using and enjoying Clang as their compiler. These tools provide developer-oriented functionality such as fast syntax checking, automatic formatting, refactoring, etc."
 :upstream_url "https://clang.llvm.org/docs/ClangTools.html#extra-clang-tools"
 :source {:url "http://llvm.org/releases/7.0.0/clang-tools-extra-7.0.0.src.tar.xz" :sha256 "937c5a8c8c43bc185e4805144744799e524059cac877a44d9063926cd7a19dbe" :filename "clang-tools-extra-7.0.0.src.tar.xz"}
 :deps ["karate/gcc-libs" "karate/glibc" "karate/zlib"]
 :build_deps ["karate/llvm" "karate/cmake" "karate/coreutils" "karate/diffutils" "karate/gcc" "karate/make" "karate/python2"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :unpack (fn [b]
          (var v-clang-src-dir "")
          (var v-clang-tools-extra-src-dir "")
          (var v-source-file "")
          (var v-unpack-dir "")
          (set v-source-file (.. b.cache "/clang-tools-extra-7.0.0.src.tar.xz"))
          (set v-unpack-dir (.. b.cache "/" b.name "-" b.version))
          (b:log "Unpacking Clang FrontEnd Source to custom cache dir")
          (b:download (.. "http://llvm.org/releases/" b.version "/cfe-" b.version ".src.tar.xz") "135f6c9b0cd2da1aff2250e065946258eb699777888df39ca5a5b4fe5e23d0ff" (.. "cfe-" b.version ".src.tar.xz"))
          (set v-clang-src-dir v-unpack-dir)
          (b:mkdir v-clang-src-dir)
          (b:run ["tar" "xf" (.. b.cache "/cfe-" b.version ".src.tar.xz") "--strip" "1" "--no-same-owner"] {:cwd v-clang-src-dir})
          (b:log "Unpacking Clang-Tools-Extra to custom cache dir")
          (set v-clang-tools-extra-src-dir (.. v-unpack-dir "/tools/extra"))
          (b:mkdir v-clang-tools-extra-src-dir)
          (b:run ["tar" "xf" v-source-file "--strip" "1" "--no-same-owner"] {:cwd v-clang-tools-extra-src-dir}))
 :build (fn [b]
          (b:mkdir (b:join b.src "build"))
          (b:run ["cmake" (.. "-DCMAKE_INSTALL_PREFIX:PATH=" b.prefix) "-DCMAKE_BUILD_TYPE=Release" "-G" "Unix Makefiles" "../"] {:cwd "build"})
          (b:run ["make" (.. "-j" (tostring b.jobs))] {:cwd "tools/extra"}))
 :check (fn [b]
          (b:run ["make" "test"] {:cwd "build/tools/extra"}))
 :install (fn [b]
          (b:run ["make" "install"] {:cwd "build/tools/extra"}))}
