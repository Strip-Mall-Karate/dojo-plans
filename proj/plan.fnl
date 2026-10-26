;; proj, ported from its plan.sh.
{:name "proj"
 :origin "karate"
 :version "4.9.3"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "Cartographic Projections Library"
 :upstream_url "https://github.com/OSGeo/proj.4"
 :source {:url "http://download.osgeo.org/proj/proj-4.9.3.tar.gz" :sha256 "6984542fea333488de5c82eea58d699e4aff4b359200a9971537cd7e047185f7"}
 :deps ["karate/glibc"]
 :build_deps ["karate/gcc" "karate/make"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]}
