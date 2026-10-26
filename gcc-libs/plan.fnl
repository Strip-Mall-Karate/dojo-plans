;; gcc-libs, ported from its plan.sh.
;; Built from the gcc plan, with its own changes.
{:name "gcc-libs"
 :origin "karate"
 :version "8.2.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0"]
 :description "Runtime libraries shipped by GCC."
 :upstream_url "https://gcc.gnu.org/"
 :source {:url "http://ftp.gnu.org/gnu/gcc/gcc-8.2.0/gcc-8.2.0.tar.xz" :sha256 "196c3c04ba2613f893283977e6011b2345d1cd1af9abeac58e916b1aab3e0080"}
 :deps ["karate/glibc"]
 :build_deps ["karate/gcc/8.2.0" "karate/patchelf"]
 :lib_dirs ["lib"]
 :download (fn [b]
          nil)
 :verify (fn [b]
          nil)
 :unpack (fn [b]
          nil)
 :prepare (fn [b]
          nil)
 :build (fn [b]
          nil)
 :install (fn [b]
          (b:mkdir (.. b.prefix "/lib"))
          (each [_ v-lib (ipairs ["libasan" "libatomic" "libgcc_s" "libgfortran" "libgomp" "libitm" "liblsan" "libquadmath" "libstdc++" "libtsan" "libubsan" "libvtv"])]
            (each [_ p (ipairs (b:glob (.. (b:path_for "gcc") "/lib") "${lib}.*"))] (b:copy p (b:join (.. b.prefix "/lib/") (: p :match "[^/]+$")))))
          (each [_ p (ipairs (b:glob (.. b.prefix "/lib") "*.spec"))] (b:remove p))
          (each [_ p (ipairs (b:glob (.. b.prefix "/lib") "*.py"))] (b:remove p))
          (b:mkdir (.. b.prefix "/share/licenses"))
          (b:copy (.. (b:path_for "gcc") "/share/licenses/RUNTIME.LIBRARY.EXCEPTION") (b:join (.. b.prefix "/share/licenses/") (: (.. (b:path_for "gcc") "/share/licenses/RUNTIME.LIBRARY.EXCEPTION") :match "[^/]+$")))
          (b:run ["find" (.. b.prefix "/lib") "-type" "f" "-name" "*.so.*" "-exec" "patchelf" "--set-rpath" (.. (b:path_for "glibc") "/lib:" b.prefix "/lib") "{}" ";"])
          (b:run ["find" (.. b.prefix "/lib") "-type" "f" "-name" "*.so.*" "-exec" "patchelf" "--shrink-rpath" "{}" ";"]))}
