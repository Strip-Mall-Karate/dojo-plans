;; llvm5, ported from its plan.sh.
;; Deprecated: true
;; Built from the llvm plan, with its own changes.
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
{:name "llvm5"
 :origin "karate"
 :version "5.0.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["NCSA"]
 :description "Next-gen compiler infrastructure"
 :upstream_url "http://llvm.org/"
 :source {:url "http://llvm.org/releases/5.0.1/llvm-5.0.1.src.tar.xz" :sha256 "5fa7489fc0225b11821cab0362f5813a05f2bcf2533e8a4ea9c9c860168807b0" :filename "llvm-5.0.1.src.tar.xz"}
 :deps ["karate/coreutils" "karate/gcc-libs" "karate/glibc" "karate/libffi" "karate/python2" "karate/zlib"]
 :build_deps ["karate/cmake" "karate/diffutils" "karate/gcc" "karate/ninja"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :download (fn [b]
          ;; From do_begin.
          (b:env "DOJ_ENV_CMAKE_FIND_ROOT_PATH_SEPARATOR" ";")
          (b:env "DOJ_ENV_CMAKE_FIND_ROOT_PATH_TYPE" "aggregate")
          (b.default.download b))
 :unpack (fn [b]
          (var v-source-file "")
          (var v-unpack-dir "")
          (b:log "Unpacking llvm-5.0.1.src.tar.xz to custom cache dir")
          (set v-source-file (.. b.cache "/llvm-5.0.1.src.tar.xz"))
          (set v-unpack-dir (.. b.prefix "/src"))
          (b:mkdir v-unpack-dir)
          (b:run ["tar" "xf" v-source-file "--strip" "1" "--no-same-owner"] {:cwd v-unpack-dir}))
 :prepare (fn [b]
          ;; From do_setup_environment.
          (b:buildtime_env "BUILD_DIR" "_build")
          (b:runtime_env_push "CMAKE_FIND_ROOT_PATH" (.. b.prefix "/lib/cmake/llvm"))
          (b:mkdir (or (b:getenv "BUILD_DIR") ""))
          (v--fix-interpreter-in-path b (.. b.prefix "/src") "*.py" "karate/python2" "bin/python")
          (v--fix-interpreter-in-path b (.. b.prefix "/src") "*.py" "karate/coreutils" "bin/env")
          (v--fix-interpreter-in-path b (.. b.prefix "/src") "*.sh" "karate/coreutils" "bin/env"))
 :build (fn [b]
          (var v--libffi-path "")
          (set v--libffi-path (b:path_for "libffi"))
          (b:run ["cmake" "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON" (.. "-DCMAKE_INSTALL_PREFIX=" b.prefix) "-DCMAKE_BUILD_TYPE=Release" "-DLLVM_ENABLE_RTTI=ON" "-DLLVM_ENABLE_FFI=ON" "-DLLVM_INSTALL_UTILS=ON" (.. "-DFFI_INCLUDE_DIR=" v--libffi-path "/lib/libffi-3.2.1/include") (.. "-DFFI_LIBRARY_DIR=" v--libffi-path "/lib") (.. "-DLLVM_BUILD_TESTS=" (or (b:getenv "DO_CHECK") "")) "-G" "Ninja" (.. b.prefix "/src")] {:cwd (or (b:getenv "BUILD_DIR") "")})
          (b:run ["ninja" (.. "-j" (b:capture ["nproc" "--ignore=1"]))] {:cwd (or (b:getenv "BUILD_DIR") "")})
          (b:copy (b:join (or (b:getenv "BUILD_DIR") "") "compile_commands.json") (.. b.prefix "/src"))
          (b:chmod (.. b.prefix "/src") "755"))
 :check (fn [b]
          (b:run ["ninja" (.. "-j" (b:capture ["nproc" "--ignore=1"])) "check-all"] {:cwd (or (b:getenv "BUILD_DIR") "")}))
 :install (fn [b]
          (b:run ["ninja" "install"] {:cwd (or (b:getenv "BUILD_DIR") "")}))
 :strip (fn [b]
          (b:log "Stripping unneeded symbols from binaries and libraries")
          (each [_ folder (ipairs ["bin" "include" "lib"])]
            (when (b:exists (b:join b.prefix folder))
              (each [_ f (ipairs (b:find (b:join b.prefix folder) "*"))]
                (when (not (b:exists (b:join f ".")))
                  (let [kind (b:capture ["file" "-bi" f])]
                    (if (: kind :find "application/x-executable" 1 true) (b:run ["strip" "--strip-all" f])
                        (: kind :find "application/x-sharedlib" 1 true) (b:run ["strip" "--strip-unneeded" f])
                        (: kind :find "application/x-archive" 1 true) (b:run ["strip" "--strip-debug" f]))))))))}
