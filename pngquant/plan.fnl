;; pngquant, ported from its plan.sh.
{:name :pngquant
 :origin :karate
 :version :2.12.2
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-3.0-only]
 :description "Lossy PNG compressor"
 :upstream_url "https://pngquant.org"
 :source {:url "https://github.com/kornelski/pngquant/archive/2.12.2.tar.gz"
          :sha256 :5edf7c5bffd07e5d28fcc6d4d94a187c30b532c52ac986b3e45aff3dce0567dc}
 :deps [:karate/coreutils :karate/libpng :karate/libimagequant :karate/zlib]
 :build_deps [:karate/make :karate/gcc :karate/pkg-config]
 :bin_dirs [:bin]
 :build (fn [b]
          (b:fix_interpreter [(b:join b.src :configure)] :karate/coreutils
                             :bin/env)
          (b.default.build b))
 :install (fn [b]
            (if (b:exists b.prefix)
                (b:copy (b:join b.src :COPYRIGHT)
                        (b:join b.prefix
                                (: (b:join b.src :COPYRIGHT) :match "[^/]+$")))
                (b:copy (b:join b.src :COPYRIGHT) b.prefix))
            (b.default.install b))}
