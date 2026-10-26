;; openjpeg, ported from its plan.sh.
{:name "openjpeg"
 :origin "karate"
 :version "2.3.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["BSD-2-Clause"]
 :description "An open source JPEG 2000 codec"
 :upstream_url "http://www.openjpeg.org/"
 :source {:url "https://github.com/uclouvain/openjpeg/archive/v2.3.1.tar.gz" :sha256 "63f5a4713ecafc86de51bfad89cc07bb788e9bba24ebbf0c4ca637621aadb6a9"}
 :deps ["karate/lcms2" "karate/libpng" "karate/libtiff" "karate/zlib"]
 :build_deps ["karate/cmake" "karate/gcc" "karate/make"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :prepare (fn [b]
          (b:mkdir (b:join b.src "build")))
 :build (fn [b]
          (b:run ["cmake" ".." (.. "-DLCMS2_INCLUDE_DIR=" (b:path_for "karate/lcms2") "/include") (.. "-DLCMS2_LIBRARY=" (b:path_for "karate/lcms2") "/lib/liblcms2.so") (.. "-DPNG_PNG_INCLUDE_DIR=" (b:path_for "karate/libpng") "/include") (.. "-DPNG_LIBRARY=" (b:path_for "karate/libpng") "/lib/libpng.so") (.. "-DTIFF_INCLUDE_DIR=" (b:path_for "karate/libtiff") "/include") (.. "-DTIFF_LIBRARY=" (b:path_for "karate/libtiff") "/lib/libtiff.so") (.. "-DZLIB_INCLUDE_DIR=" (b:path_for "karate/zlib") "/include") (.. "-DZLIB_LIBRARY=" (b:path_for "karate/zlib") "/lib/libz.so") "-DCMAKE_BUILD_TYPE=Release" (.. "-DCMAKE_INSTALL_PREFIX=" b.prefix)] {:cwd "build"})
          (b:run ["make"] {:cwd "build"}))
 :install (fn [b]
          (b:run ["make" "install"] {:cwd "build"}))}
