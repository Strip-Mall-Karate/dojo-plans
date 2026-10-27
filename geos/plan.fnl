;; geos, ported from its plan.sh.
{:name :geos
 :origin :karate
 :version :3.7.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:LGPL]
 :description "GEOS (Geometry Engine - Open Source) is a C++ port of the ​Java Topology Suite (JTS)."
 :upstream_url "http://trac.osgeo.org/geos"
 :source {:url "http://download.osgeo.org/geos/geos-3.7.1.tar.bz2"
          :sha256 :0006c7b49eaed016b9c5c6f872417a7d7dc022e069ddd683335793d905a8228c}
 :deps [:karate/coreutils :karate/glibc :karate/gcc-libs]
 :build_deps [:karate/gcc :karate/make :karate/patchelf]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :install (fn [b]
            (b.default.install b)
            (b:log "Patching ELF binaries:")
            (b:run [:find
                    (.. b.prefix :/lib)
                    :-type
                    :f
                    :-executable
                    :-exec
                    :sh
                    :-c
                    "file -i \"$1\" | grep -q \"x-sharedlib; charset=binary\""
                    "_"
                    "{}"
                    ";"
                    :-print
                    :-exec
                    :patchelf
                    :--set-rpath
                    (or (b:getenv :LD_RUN_PATH) "")
                    "{}"
                    ";"]))}
