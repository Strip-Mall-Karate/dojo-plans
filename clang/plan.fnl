;; clang, ported from its plan.sh.
(fn v--fix-interpreter-in-path [b a1 a2 a3 a4]
  (var v-fileending "")
  (var v-int "")
  (var v-path "")
  (var v-pkg "")
  (set v-path a1)
  (set v-fileending a2)
  (set v-pkg a3)
  (set v-int a4)
  ;; Each text file under path named like fileending whose #! names int, pointed
  ;; at the dependency's: b:fix_interpreter rewrites only a #! line that names it.
  (each [_ f (ipairs (b:find v-path v-fileending))]
    (when (not (b:exists (b:join f ".")))
      (b:fix_interpreter [f] v-pkg v-int)))
  ;; The files the find above listed are fixed there.
  )

{:name :clang
 :origin :karate
 :version :7.0.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:NCSA]
 :description "LLVM native C/C++/Objective-C compiler"
 :upstream_url "http://clang.llvm.org/"
 :source {:url "http://llvm.org/releases/7.0.1/cfe-7.0.1.src.tar.xz"
          :sha256 :a45b62dde5d7d5fdcdfa876b0af92f164d434b06e9e89b5d0b1cbc65dfe3f418
          :filename :cfe-7.0.1.src.tar.xz}
 :deps [:karate/coreutils
        :karate/gcc-libs
        :karate/glibc
        :karate/python
        :karate/zlib
        :karate/perl
        :karate/gcc]
 :build_deps [:karate/llvm
              :karate/perl
              :karate/cmake
              :karate/diffutils
              :karate/ninja]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :download (fn [b]
             ;; From do_begin.
             (b:env :DOJ_ENV_CMAKE_FIND_ROOT_PATH_SEPARATOR ";")
             (b:env :DOJ_ENV_CMAKE_FIND_ROOT_PATH_TYPE :aggregate)
             (b.default.download b))
 :unpack (fn [b]
           (var v-clang-tools-extra-src-dir "")
           (var v-source-file "")
           (var v-unpack-dir "")
           (b:log "Unpacking cfe-7.0.1.src.tar.xz to custom cache dir")
           (set v-source-file (.. b.cache :/cfe-7.0.1.src.tar.xz))
           (set v-unpack-dir (.. b.cache "/" b.name "-" b.version))
           (b:mkdir v-unpack-dir)
           (b:run [:tar :xf v-source-file :--strip :1 :--no-same-owner]
                  {:cwd v-unpack-dir})
           (b:download (.. "http://llvm.org/releases/" b.version
                           :/clang-tools-extra- b.version :.src.tar.xz)
                       :937c5a8c8c43bc185e4805144744799e524059cac877a44d9063926cd7a19dbe
                       (.. :clang-tools-extra- b.version :.src.tar.xz))
           (b:log "Unpacking clang-tools-extra to custom cache dir")
           (set v-clang-tools-extra-src-dir (.. v-unpack-dir :/tools/extra))
           (b:mkdir v-clang-tools-extra-src-dir)
           (b:run [:tar
                   :xf
                   (.. b.cache :/clang-tools-extra- b.version :.src.tar.xz)
                   :--strip
                   :1
                   :--no-same-owner]
                  {:cwd v-clang-tools-extra-src-dir}))
 :prepare (fn [b]
            ;; From do_setup_environment.
            (b:buildtime_env :BUILD_DIR :_build)
            (b:runtime_env_push :CMAKE_FIND_ROOT_PATH
                                (.. b.prefix :/lib/cmake/clang))
            (b:mkdir (or (b:getenv :BUILD_DIR) ""))
            (v--fix-interpreter-in-path b
                                        (.. b.cache "/"
                                            (.. b.name "-" b.version))
                                        :*.py :karate/python :bin/python)
            (v--fix-interpreter-in-path b
                                        (.. b.cache "/"
                                            (.. b.name "-" b.version))
                                        :*.py :karate/coreutils :bin/env)
            (v--fix-interpreter-in-path b
                                        (.. b.cache "/"
                                            (.. b.name "-" b.version))
                                        :*.sh :karate/coreutils :bin/env))
 :build (fn [b]
          (b:run [:cmake
                  (.. :-DCMAKE_INSTALL_PREFIX= b.prefix)
                  :-DCLANG_BUILD_EXAMPLES=ON
                  :-DLLVM_ENABLE_RTTI=ON
                  :-DCMAKE_BUILD_TYPE=Release
                  :-G
                  :Ninja
                  ".."] {:cwd (or (b:getenv :BUILD_DIR) "")})
          (b:run [:ninja (.. :-j (b:capture [:nproc :--ignore=1]))]
                 {:cwd (or (b:getenv :BUILD_DIR) "")}))
 :check (fn [b]
          (b:run [:ninja
                  (.. :-j (b:capture [:nproc :--ignore=1]))
                  :check-clang]
                 {:cwd (or (b:getenv :BUILD_DIR) "")}))
 :install (fn [b]
            (b:run [:ninja :install] {:cwd (or (b:getenv :BUILD_DIR) "")})
            (b:fix_interpreter [(.. b.prefix :/bin/git-clang-format)]
                               :karate/coreutils :bin/env)
            (b:fix_interpreter [(.. b.prefix :/bin/hmaptool)] :karate/coreutils
                               :bin/env)
            (b:fix_interpreter [(.. b.prefix :/bin/scan-build)]
                               :karate/coreutils :bin/env)
            (b:fix_interpreter [(.. b.prefix :/bin/scan-view)]
                               :karate/coreutils :bin/env)
            (b:fix_interpreter [(.. b.prefix :/libexec/c++-analyzer)]
                               :karate/coreutils :bin/env)
            (b:fix_interpreter [(.. b.prefix :/libexec/ccc-analyzer)]
                               :karate/coreutils :bin/env))}
