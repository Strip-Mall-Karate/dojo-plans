;; gdal, ported from its plan.sh.
{:name "gdal"
 :origin "karate"
 :version "2.4.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "GDAL is a translator library for raster and vector geospatial data formats"
 :upstream_url "http://www.gdal.org/"
 :source {:url "http://download.osgeo.org/gdal/2.4.0/gdal-2.4.0.tar.gz" :sha256 "a568cf3dc7bb203ae12a48e1eb2a42302cded499ef6eccaf9e8f09187d8ce75a"}
 :deps ["karate/gcc-libs" "karate/glibc"]
 :build_deps ["karate/gcc" "karate/make" "karate/pkg-config" "karate/patchelf"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :install (fn [b]
          (b.default.install b)
          (b:log "Patching ELF binaries:")
          (b:run ["find" (.. b.prefix "/lib") "-type" "f" "-executable" "-exec" "sh" "-c" "file -i \"$1\" | grep -q \"x-sharedlib; charset=binary\"" "_" "{}" ";" "-print" "-exec" "patchelf" "--set-rpath" (or (b:getenv "LD_RUN_PATH") "") "{}" ";"]))}
