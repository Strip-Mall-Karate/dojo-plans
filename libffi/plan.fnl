;; libffi, ported from its plan.sh.
;; libffi 3.8.0, the latest release on 2026-10-26: 3.2.1's source no longer downloads.
{:name :libffi
 :origin :karate
 :version :3.8.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :source {:url "https://github.com/libffi/libffi/releases/download/v3.8.0/libffi-3.8.0.tar.gz"
          :sha256 :7da3e2d9a171eb0a038f592ecad3ff2bb2550f3496d87b3b29ad0cf4430c0db4
          :filename :libffi-3.8.0.tar.gz}
 :deps [:karate/glibc :karate/libtool]
 :build_deps [:karate/coreutils :karate/make :karate/gcc]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :build (fn [b]
          (b:run [:./configure
                  (.. :--prefix= b.prefix)
                  :--disable-multi-os-directory])
          (b:run [:make]))}
