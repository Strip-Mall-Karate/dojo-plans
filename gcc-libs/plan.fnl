;; gcc-libs, ported from its plan.sh.
;; gcc-libs 16.2.0, the latest release on 2026-10-26.
;; Built from the gcc plan, with its own changes.
{:name :gcc-libs
 :origin :karate
 :version :16.2.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-2.0]
 :description "Runtime libraries shipped by GCC."
 :upstream_url "https://gcc.gnu.org/"
 :source {:url "https://ftp.gnu.org/gnu/gcc/gcc-16.2.0/gcc-16.2.0.tar.xz"
          :sha256 :e6738e29597f733270731aa90600f37ffdc045079dfc27ec7e8192cc81085c3e}
 :deps [:karate/glibc]
 :build_deps [:karate/gcc/16.2.0 :karate/patchelf]
 :lib_dirs [:lib]
 :download (fn [_b]
             nil)
 :verify (fn [_b]
           nil)
 :unpack (fn [_b]
           nil)
 :prepare (fn [_b]
            nil)
 :build (fn [_b]
          nil)
 :install (fn [b]
            (b:mkdir (.. b.prefix :/lib))
            (each [_ v-lib (ipairs [:libasan
                                    :libatomic
                                    :libgcc_s
                                    :libgfortran
                                    :libgomp
                                    :libitm
                                    :liblsan
                                    :libquadmath
                                    :libstdc++
                                    :libtsan
                                    :libubsan
                                    :libvtv])]
              (each [_ p (ipairs (b:glob (.. (b:path_for :gcc) :/lib)
                                         (.. v-lib ".*")))]
                (b:copy p (b:join (.. b.prefix :/lib/) (p:match "[^/]+$")))))
            (each [_ p (ipairs (b:glob (.. b.prefix :/lib) :*.spec))]
              (b:remove p))
            (each [_ p (ipairs (b:glob (.. b.prefix :/lib) :*.py))]
              (b:remove p))
            (b:mkdir (.. b.prefix :/share/licenses))
            (b:copy (.. (b:path_for :gcc)
                        :/share/licenses/RUNTIME.LIBRARY.EXCEPTION)
                    (b:join (.. b.prefix :/share/licenses/)
                            (: (.. (b:path_for :gcc)
                                   :/share/licenses/RUNTIME.LIBRARY.EXCEPTION)
                               :match "[^/]+$")))
            (b:run [:find
                    (.. b.prefix :/lib)
                    :-type
                    :f
                    :-name
                    :*.so.*
                    :-exec
                    :patchelf
                    :--set-rpath
                    (.. (b:path_for :glibc) "/lib:" b.prefix :/lib)
                    "{}"
                    ";"])
            (b:run [:find
                    (.. b.prefix :/lib)
                    :-type
                    :f
                    :-name
                    :*.so.*
                    :-exec
                    :patchelf
                    :--shrink-rpath
                    "{}"
                    ";"]))}
