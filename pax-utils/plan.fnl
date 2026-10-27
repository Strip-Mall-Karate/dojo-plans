;; pax-utils, ported from its plan.sh.
;; pax-utils 1.3.11, the latest release on 2026-10-27: 1.2.3's source no longer downloads.
{:name :pax-utils
 :origin :karate
 :version :1.3.11
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL]
 :description "ELF related utils for ELF 32/64 binaries that can check files
for security relevant properties"
 :upstream_url "https://gitweb.gentoo.org/proj/pax-utils.git"
 :source {:url "https://distfiles.gentoo.org/pub/proj/toolchain/pax-utils/pax-utils-1.3.11.tar.xz"
          :sha256 :0ca000bca244e22589e38f1db0daaeaf4cc8b2960381fc7cf673cc3296b8d6f5}
 :deps [:karate/bash :karate/glibc :karate/libcap]
 :build_deps [:karate/diffutils
              :karate/gcc
              :karate/meson
              :karate/ninja
              :karate/pkg-config]
 :bin_dirs [:bin]
 :build (fn [b]
          (b:run [:meson
                  :setup
                  :_build
                  (.. :--prefix= b.prefix)
                  :--buildtype=release
                  :-Duse_libcap=enabled
                  :-Dlddtree_implementation=sh
                  :-Dbuild_manpages=disabled
                  :-Duse_fuzzing=false])
          (b:run [:ninja :-C :_build]))
 :check (fn [b]
          (b:run [:meson :test :-C :_build]))
 :install (fn [b]
            (b:run [:ninja :-C :_build :install])
            (b:fix_interpreter (b:glob (.. b.prefix :/bin) "*") :karate/bash
                               :bin/bash))}
