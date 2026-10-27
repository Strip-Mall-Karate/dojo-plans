;; sassc, ported from its plan.sh.
{:name :sassc
 :origin :karate
 :version :3.3.6
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "libsass command line driver"
 :upstream_url "https://github.com/sass/sassc"
 :source {:url "https://github.com/sass/sassc/archive/3.3.6.tar.gz"
          :sha256 :3d87edeacdd0f9a21cd0bdcf0e0e40c832b21f469af80eb5e11488c66bf53840}
 :deps [:karate/glibc :karate/gcc-libs]
 :build_deps [:karate/make :karate/gcc :karate/coreutils]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :download (fn [b]
             (b.default.download b)
             (b:download (.. "https://github.com/sass/libsass/archive/"
                             b.version :.tar.gz)
                         :4b004b0fcef55420dc916216b1961e0d86925e6bf4a6be37d0b6db42f7f25da5
                         :libsass.tar.gz))
 :unpack (fn [b]
           (b.default.unpack b)
           (b:run [:tar :-xzf (.. b.cache :/libsass.tar.gz) :-C b.cache]))
 :build (fn [b]
          (b:env :SASS_LIBSASS_PATH (.. b.cache :/libsass- b.version))
          (b:run [:make]))
 :install (fn [b]
            (b:copy (b:join b.src :bin/sassc) (.. b.prefix :/bin/sassc))
            (b:chmod (.. b.prefix :/bin/sassc) :755))}
