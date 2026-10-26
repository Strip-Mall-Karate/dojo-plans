;; cuda, ported from its plan.sh.
(fn use-dependency-path [b path replacement]
  ;; The source project's studio linked a dependency's tool to `path` for the
  ;; build. A Dojo build writes nothing outside itself, so the build's scripts
  ;; name the dependency's tool instead.
  (each [_ f (ipairs (b:find b.src "*"))]
    (let [name (: f :match "[^/]+$")]
      (when (and (or (: name :match "^configure") (: name :match "^Makefile") (: name :match "^ltmain")
                     (: name :match "%.in$") (: name :match "%.am$") (: name :match "%.ac$")
                     (: name :match "%.m4$") (: name :match "%.mk$") (: name :match "%.sh$")
                     (: name :match "%.pl$") (: name :match "%.py$"))
                 (not (b:exists (b:join f "."))))
        (let [text (b:read f)
              escaped (pick-values 1 (: path :gsub "[%^%$%(%)%%%.%[%]%*%+%-%?]" "%%%0"))
              (fixed n) (: text :gsub escaped (pick-values 1 (: replacement :gsub "%%" "%%%%")))]
          (when (> n 0) (b:write f fixed)))))))
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
{:name "cuda"
 :origin "karate"
 :version "9.2.148"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["custom"]
 :description "GPU-accelerated Libraries for Computing on NVIDIA devices"
 :upstream_url "https://developer.nvidia.com/cuda-zone"
 :source {:url "https://developer.nvidia.com/compute/cuda/9.2/Prod2/local_installers/cuda_9.2.148_396.37_linux" :sha256 "f5454ec2cfdf6e02979ed2b1ebc18480d5dded2ef2279e9ce68a505056da8611" :filename "cuda_9.2.148_396.37_linux.run"}
 :deps ["karate/gcc-libs" "karate/glibc" "karate/ncurses" "karate/gcc" "karate/python2" "karate/corretto8" "karate/coreutils" "karate/busybox-static"]
 :build_deps ["karate/make" "karate/patchelf" "karate/perl"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib64" "lib64/stubs" "nvvm/lib64"]
 :include_dirs ["include"]
 :download (fn [b]
          ;; From do_before.
          (use-dependency-path b "/usr/bin/perl" (b:path_for "perl" "bin/perl"))
          (use-dependency-path b "/bin/rm" (b:path_for "coreutils" "bin/rm"))
          (b.default.download b))
 :unpack (fn [b]
          (b:run ["sh" "cuda_9.2.148_396.37_linux.run" (.. "--extract=" b.cache "/" (.. b.name "-" b.version))] {:cwd b.cache})
          (each [_ program (ipairs (b:glob (.. b.name "-" b.version) "cuda-*.run"))]
            (b:run [program "--noexec" "--keep"] {:cwd (.. b.name "-" b.version)}))
          (each [_ program (ipairs (b:glob (.. b.name "-" b.version) "cuda-samples*.run"))]
            (b:run [program "--noexec" "--keep"] {:cwd (.. b.name "-" b.version)})))
 :prepare (fn [b]
          (let [text (b:read (b:join b.src "pkg/install-linux.pl")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line "/usr/share" (.. (pick-values 1 (: b.prefix :gsub "%%" "%%%%")) "/share")))))
              (when (not deleted) (set line (pick-values 1 (string.gsub line "can_add_for_all_users;" "1;"))))
              (when (not deleted) (set line (pick-values 1 (string.gsub line "Terminal=No" "Terminal=false"))))
              (when (not deleted) (set line (pick-values 1 (string.gsub line "ParallelComputing" "ParallelComputing;"))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join b.src "pkg/install-linux.pl") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" ""))))
          (v--fix-interpreter-in-path b "pkg" "*.py" "karate/python2" "bin/python")
          (v--fix-interpreter-in-path b "pkg" "*.py" "karate/coreutils" "bin/env"))
 :build (fn [b]
          nil)
 :check (fn [b]
          nil)
 :install (fn [b]
          (var v--cuda-bins "")
          (var v--cuda-libs "")
          (var v--cuda-stubs-libs "")
          (b:env "PERL5LIB" ".")
          (b:run ["perl" "install-linux.pl" (.. "-prefix=" b.prefix) "-noprompt" "-nosymlink"] {:cwd "pkg"})
          (b:run ["perl" "install-sdk-linux.pl" (.. "-cudaprefix=" b.prefix) (.. "-prefix=" b.prefix "/samples") "-noprompt"] {:cwd "pkg"})
          (let [text (b:read (.. b.prefix "/include/host_defines.h")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (when (= n 1) (table.insert out "#define _BITS_FLOATN_H")))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (.. b.prefix "/include/host_defines.h") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" ""))))
          (let [link (if (b:exists (b:join (.. b.prefix "/bin/gcc") ".")) (b:join (.. b.prefix "/bin/gcc") (: (.. (b:path_for "karate/gcc") "/bin/gcc") :match "[^/]+$")) (.. b.prefix "/bin/gcc"))]
            (b:symlink (.. (b:path_for "karate/gcc") "/bin/gcc") link))
          (let [link (if (b:exists (b:join (.. b.prefix "/bin/g++") ".")) (b:join (.. b.prefix "/bin/g++") (: (.. (b:path_for "karate/gcc") "/bin/g++") :match "[^/]+$")) (.. b.prefix "/bin/g++"))]
            (b:symlink (.. (b:path_for "karate/gcc") "/bin/g++") link))
          (b:mkdir (.. b.prefix "/etc/profile.d"))
          (b:write (.. b.prefix "/etc/profile.d/cuda.sh") (.. "export PATH=$PATH:" b.prefix "/bin\n"))
          (b:chmod (.. b.prefix "/etc/profile.d/cuda.sh") "0755")
          (b:mkdir (.. b.prefix "/etc/ld.so.conf.d"))
          (b:write (.. b.prefix "/etc/ld.so.conf.d/cuda.conf") (.. b.prefix "/lib64\n" b.prefix "/nvvm/lib64\n"))
          (b:chmod (.. b.prefix "/etc/ld.so.conf.d/cuda.conf") "0644")
          (b:mkdir (.. b.prefix "/share/licenses"))
          (if (b:exists (.. b.prefix "/share/licenses/EULA.pdf"))
            (b:copy (.. b.prefix "/doc/pdf/EULA.pdf") (b:join (.. b.prefix "/share/licenses/EULA.pdf") (: (.. b.prefix "/doc/pdf/EULA.pdf") :match "[^/]+$")))
            (b:copy (.. b.prefix "/doc/pdf/EULA.pdf") (.. b.prefix "/share/licenses/EULA.pdf")))
          (b:remove (.. b.prefix "/cuda-samples"))
          (b:remove (.. b.prefix "/samples"))
          (b:remove (.. b.prefix "/doc"))
          (b:remove (.. b.prefix "/usr/share/man"))
          (b:remove (.. b.prefix "/jre"))
          (let [text (b:read (.. b.prefix "/libnsight/nsight.ini")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line "../jre/bin/java" (.. (pick-values 1 (: (b:path_for "karate/corretto8") :gsub "%%" "%%%%")) "/bin/java")))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (.. b.prefix "/libnsight/nsight.ini") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" ""))))
          (let [text (b:read (.. b.prefix "/libnvvp/nvvp.ini")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line "../jre/bin/java" (.. (pick-values 1 (: (b:path_for "karate/corretto8") :gsub "%%" "%%%%")) "/bin/java")))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (.. b.prefix "/libnvvp/nvvp.ini") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" ""))))
          (b:remove (.. b.prefix "/bin/.uninstall_manifest_do_not_delete.txt"))
          (each [_ p (ipairs (b:glob (.. b.prefix "/bin") "cuda-install-samples*.sh"))] (b:remove p))
          (each [_ p (ipairs (b:glob (.. b.prefix "/bin") "uninstall_cuda_toolkit*.pl"))] (b:remove p))
          (b:fix_interpreter [(.. b.prefix "/bin/computeprof")] "karate/busybox-static" "bin/sh")
          (b:fix_interpreter [(.. b.prefix "/bin/nvvp")] "karate/busybox-static" "bin/sh")
          (b:fix_interpreter [(.. b.prefix "/bin/nsight")] "karate/busybox-static" "bin/sh")
          (b:fix_interpreter [(.. b.prefix "/bin/nsight_ee_plugins_manage.sh")] "karate/busybox-static" "bin/sh")
          (var v-cuda-run-path (.. b.prefix "/lib64:" b.prefix "/nvvm/lib64:" (b:path_for "gcc-libs") "/lib:" (b:path_for "glibc") "/lib"))
          (set v--cuda-bins ["nvvm/bin/cicc" "libnvvp/nvvp" "libnsight/nsight" "extras/demo_suite/bandwidthTest" "extras/demo_suite/busGrind" "extras/demo_suite/deviceQuery" "extras/demo_suite/nbody" "extras/demo_suite/oceanFFT" "extras/demo_suite/randomFog" "extras/demo_suite/vectorAdd" "bin/bin2c" "bin/cudafe++" "bin/cuobjdump" "bin/fatbinary" "bin/nvcc" "bin/nvdisasm" "bin/nvlink" "bin/nvprof" "bin/nvprune" "bin/ptxas" "bin/cuda-gdbserver" "bin/cuda-memcheck" "bin/gpu-library-advisor"])
          (each [_ v-bin (ipairs v--cuda-bins)]
            (b:log (.. "patch " b.prefix "/" v-bin)) (b:run ["patchelf" "--interpreter" (.. (b:path_for "glibc") "/lib/ld-linux-x86-64.so.2") "--set-rpath" v-cuda-run-path (.. b.prefix "/" v-bin)] {:cwd "pkg"}))
          (b:log (.. "patch " b.prefix "/bin/cuda-gdb"))
          (b:run ["patchelf" "--interpreter" (.. (b:path_for "glibc") "/lib/ld-linux-x86-64.so.2") (.. b.prefix "/bin/cuda-gdb")] {:cwd "pkg"})
          (b:run ["patchelf" "--replace-needed" "libncurses.so.5" "libncurses.so.6" (.. b.prefix "/bin/cuda-gdb")] {:cwd "pkg"})
          (b:run ["patchelf" "--set-rpath" (.. v-cuda-run-path ":" (b:path_for "ncurses") "/lib") (.. b.prefix "/bin/cuda-gdb")] {:cwd "pkg"})
          (set v--cuda-libs ["libOpenCL" "libcufftw" "libnppc" "libnppif" "libnppitc" "libnvrtc-builtins" "libaccinj64" "libcuinj64" "libnppial" "libnppig" "libnpps" "libnvrtc" "libcublas" "libcurand" "libnppicc" "libnppim" "libnvToolsExt" "libcudart" "libcusolver" "libnppicom" "libnppist" "libnvblas" "libcufft" "libcusparse" "libnppidei" "libnppisu" "libnvgraph"])
          (each [_ v-lib (ipairs v--cuda-libs)]
            (b:log (.. "patch " b.prefix "/lib64/" v-lib ".so")) (b:run ["patchelf" "--set-rpath" v-cuda-run-path (.. b.prefix "/lib64/" v-lib ".so")] {:cwd "pkg"}))
          (set v--cuda-stubs-libs ["libcublas" "libcurand" "libnppial" "libnppif" "libnppisu" "libnvidia-ml" "libcuda" "libcusolver" "libnppicc" "libnppig" "libnppitc" "libnvrtc" "libcufft" "libcusparse" "libnppicom" "libnppim" "libnpps" "libcufftw" "libnppc" "libnppidei" "libnppist" "libnvgraph"])
          (each [_ v-lib (ipairs v--cuda-stubs-libs)]
            (b:log (.. "patch " b.prefix "/lib64/stubs/" v-lib ".so")) (b:run ["patchelf" "--set-rpath" v-cuda-run-path (.. b.prefix "/lib64/stubs/" v-lib ".so")] {:cwd "pkg"}))
          (b:log (.. "patch " b.prefix "/nvvm/lib64/libnvvm.so"))
          (b:run ["patchelf" "--set-rpath" v-cuda-run-path (.. b.prefix "/nvvm/lib64/libnvvm.so")] {:cwd "pkg"})
          (b:log (.. "patch " b.prefix "/extras/CUPTI/lib64/libcupti.so"))
          (b:run ["patchelf" "--set-rpath" v-cuda-run-path (.. b.prefix "/extras/CUPTI/lib64/libcupti.so")] {:cwd "pkg"}))
 :strip (fn [b]
          ;; From do_end.
          )}
