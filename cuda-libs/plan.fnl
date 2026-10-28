;; cuda-libs, ported from its plan.sh.
;; Built from the cuda plan, with its own changes.
(fn use-dependency-path [b path replacement]
  ;; The source project's studio linked a dependency's tool to `path` for the
  ;; build. A Dojo build writes nothing outside itself, so the build's scripts
  ;; name the dependency's tool instead.
  (each [_ f (ipairs (b:find b.src "*"))]
    (let [name (f:match "[^/]+$")]
      (when (and (or (name:match :^configure) (name:match :^Makefile)
                     (name:match :^ltmain) (name:match "%.in$")
                     (name:match "%.am$") (name:match "%.ac$")
                     (name:match "%.m4$") (name:match "%.mk$")
                     (name:match "%.sh$") (name:match "%.pl$")
                     (name:match "%.py$"))
                 (not (b:exists (b:join f "."))))
        (let [text (b:read f)
              escaped (pick-values 1
                                   (path:gsub "[%^%$%(%)%%%.%[%]%*%+%-%?]"
                                              "%%%0"))
              (fixed n) (text:gsub escaped
                                   (pick-values 1
                                                (replacement:gsub "%%" "%%%%")))]
          (when (> n 0) (b:write f fixed)))))))

{:name :cuda-libs
 :origin :karate
 :version :9.2.148
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:custom]
 :description "Runtime libraries shipped by Nvidia CUDA"
 :upstream_url "https://developer.nvidia.com/cuda-zone"
 :source {:url "https://developer.nvidia.com/compute/cuda/9.2/Prod2/local_installers/cuda_9.2.148_396.37_linux"
          :sha256 :f5454ec2cfdf6e02979ed2b1ebc18480d5dded2ef2279e9ce68a505056da8611
          :filename :cuda_9.2.148_396.37_linux.run}
 :deps [:karate/gcc-libs :karate/glibc]
 :build_deps [:karate/cuda/9.2.148 :karate/patchelf]
 :lib_dirs [:lib64 :lib64/stubs :nvvm/lib64]
 :download (fn [b]
             ;; From do_before.
             (use-dependency-path b :/usr/bin/perl (b:path_for :perl :bin/perl))
             (use-dependency-path b :/bin/rm (b:path_for :coreutils :bin/rm)))
 :verify (fn [_b]
           nil)
 :unpack (fn [_b]
           nil)
 :prepare (fn [_b]
            nil)
 :build (fn [_b]
          nil)
 :install (fn [b]
            (var v--cuda-libs "")
            (var v--cuda-stubs-libs "")
            (local v-cuda-run-path
                   (.. b.prefix "/lib64:" b.prefix "/nvvm/lib64:"
                       (b:path_for :gcc-libs) "/lib:" (b:path_for :glibc) :/lib))
            (set v--cuda-libs [:libOpenCL
                               :libcufftw
                               :libnppc
                               :libnppif
                               :libnppitc
                               :libnvrtc-builtins
                               :libaccinj64
                               :libcuinj64
                               :libnppial
                               :libnppig
                               :libnpps
                               :libnvrtc
                               :libcublas
                               :libcurand
                               :libnppicc
                               :libnppim
                               :libnvToolsExt
                               :libcudart
                               :libcusolver
                               :libnppicom
                               :libnppist
                               :libnvblas
                               :libcufft
                               :libcusparse
                               :libnppidei
                               :libnppisu
                               :libnvgraph])
            (each [_ v-lib (ipairs v--cuda-libs)]
              (each [_ p (ipairs (b:glob (.. (b:path_for :karate/cuda) :/lib64)
                                         (.. v-lib ".*")))]
                (b:copy p (b:join (.. b.prefix :/lib64/) (p:match "[^/]+$"))))
              (b:run [:patchelf
                      :--set-rpath
                      v-cuda-run-path
                      (.. b.prefix :/lib64/ v-lib :.so)]))
            (set v--cuda-stubs-libs
                 [:libcublas
                  :libcurand
                  :libnppial
                  :libnppif
                  :libnppisu
                  :libnvidia-ml
                  :libcuda
                  :libcusolver
                  :libnppicc
                  :libnppig
                  :libnppitc
                  :libnvrtc
                  :libcufft
                  :libcusparse
                  :libnppicom
                  :libnppim
                  :libnpps
                  :libcufftw
                  :libnppc
                  :libnppidei
                  :libnppist
                  :libnvgraph])
            (each [_ v-lib (ipairs v--cuda-stubs-libs)]
              (each [_ p (ipairs (b:glob (.. (b:path_for :karate/cuda)
                                             :/lib64/stubs)
                                         (.. v-lib ".*")))]
                (b:copy p (b:join (.. b.prefix :/lib64/stubs/)
                                  (p:match "[^/]+$"))))
              (b:run [:patchelf
                      :--set-rpath
                      v-cuda-run-path
                      (.. b.prefix :/lib64/stubs/ v-lib :.so)]))
            (each [_ p (ipairs (b:glob (.. (b:path_for :karate/cuda)
                                           :/nvvm/lib64)
                                       :libnvvm.*))]
              (b:copy p (b:join (.. b.prefix :/nvvm/lib64/) (p:match "[^/]+$"))))
            (b:run [:patchelf
                    :--set-rpath
                    v-cuda-run-path
                    (.. b.prefix :/nvvm/lib64/libnvvm.so)])
            (b:mkdir (.. b.prefix :/share/licenses))
            (if (b:exists (.. b.prefix :/share/licenses/EULA.pdf))
                (b:copy (.. (b:path_for :karate/cuda) :/share/licenses/EULA.pdf)
                        (b:join (.. b.prefix :/share/licenses/EULA.pdf)
                                (: (.. (b:path_for :karate/cuda)
                                       :/share/licenses/EULA.pdf)
                                   :match "[^/]+$")))
                (b:copy (.. (b:path_for :karate/cuda) :/share/licenses/EULA.pdf)
                        (.. b.prefix :/share/licenses/EULA.pdf))))
 :strip (fn [_b]
          ;; From do_end.
          )}
