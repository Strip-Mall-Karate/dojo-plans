;; libimagequant, ported from its plan.sh.
{:name :libimagequant
 :origin :karate
 :version :2.12.2
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-3.0-or-later]
 :description "Small, portable C library for high-quality conversion of RGBA images to 8-bit indexed-color (palette) images."
 :upstream_url "https://pngquant.org/lib"
 :source {:url "https://github.com/ImageOptim/libimagequant/archive/2.12.2.tar.gz"
          :sha256 :23ccecb4898ec17474914cfd2fbc4684425f7fd249117f2f1e3f3ba0bf8159e6}
 :deps [:karate/coreutils]
 :build_deps [:karate/make :karate/gcc]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :build (fn [b]
          (b:fix_interpreter [(b:join b.src :configure)] :karate/coreutils
                             :bin/env)
          (b.default.build b))}
