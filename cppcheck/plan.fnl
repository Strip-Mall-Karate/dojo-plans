;; cppcheck, ported from its plan.sh.
{:name "cppcheck"
 :origin "karate"
 :version "1.86"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-3.0"]
 :description "static analysis of C/C++ code"
 :upstream_url "http://cppcheck.sourceforget.net"
 :source {:url "https://github.com/danmar/cppcheck/archive/1.86.tar.gz" :sha256 "86ea85c2ee5ec31a7410bfc7c206b87e600d284089428750d66d1ce1ffa0c9a6" :filename "1.86.tar.gz"}
 :deps ["karate/glibc" "karate/gcc-libs" "karate/pcre"]
 :build_deps ["karate/pkg-config" "karate/cmake" "karate/ninja" "karate/gcc"]
 :bin_dirs ["bin"]
 :prepare (fn [b]
          ;; From do_setup_environment.
          (b:env "BUILDDIR" "_build")
          (b:mkdir (or (b:getenv "BUILDDIR") "")))
 :build (fn [b]
          (var v--pcre-path "")
          (set v--pcre-path (b:path_for "pcre"))
          (b:run ["cmake" (.. "-DCMAKE_INSTALL_PREFIX=" b.prefix) (.. "-DBUILD_TESTS=" (or (b:getenv "DO_CHECK") "")) "-DHAVE_RULES=yes" (.. "-DPCRE=" v--pcre-path "/lib") "-G" "Ninja" ".."] {:cwd (or (b:getenv "BUILDDIR") "")})
          (b:run ["ninja"] {:cwd (or (b:getenv "BUILDDIR") "")}))
 :check (fn [b]
          (b:run ["ctest" "-V"] {:cwd (or (b:getenv "BUILDDIR") "")}))
 :install (fn [b]
          (b:run ["ninja" "install"] {:cwd (or (b:getenv "BUILDDIR") "")}))}
