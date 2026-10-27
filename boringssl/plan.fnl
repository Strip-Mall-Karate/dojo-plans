;; boringssl, ported from its plan.sh.
;; The source project's plan took googlesource's archive of branch 3538,
;; unverified; those archives are made afresh on each request. This is the
;; branch's head (unchanged since 23 August 2018) from the GitHub mirror, pinned.
;; That archive keeps its files in one directory, so the plan's `..` (the cache,
;; where googlesource's flat archive landed) is that directory here.
{:name :boringssl
 :origin :karate
 :version :3538
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license ["OpenSSL ISC"]
 :description "BoringSSL is a fork of OpenSSL that is designed to meet Google\\'s needs."
 :upstream_url "https://boringssl.googlesource.com/boringssl/"
 :source {:url "https://github.com/google/boringssl/archive/7f4f41fa81c03e0f8ef1ab5b3d1d566b5968f107.tar.gz"
          :sha256 :f44fa8bd4d7c42e4b344ee518a04c8b2e30083a2446e99d9d645f352c066512f
          :filename :boringssl-3538.tar.gz
          :dirname :boringssl-7f4f41fa81c03e0f8ef1ab5b3d1d566b5968f107}
 :deps [:karate/glibc
        :karate/go
        :karate/cmake
        :karate/ninja
        :karate/perl
        :karate/gcc]
 :build_deps [:karate/glibc :karate/gcc-libs]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :build (fn [b]
          (b:mkdir (b:join b.src :build))
          (b:run [:cmake :-GNinja ".."] {:cwd :build})
          (b:run [:ninja] {:cwd :build}))
 :install (fn [b]
            (b:mkdir (.. b.prefix :/bin))
            (b:mkdir (.. b.prefix :/include))
            (b:mkdir (.. b.prefix :/lib))
            (b:move (b:join b.src :build/tool/bssl) (.. b.prefix :/bin/bssl))
            (b:move (b:join b.src :build/ssl/libssl.a)
                    (.. b.prefix :/lib/libssl.a))
            (b:move (b:join b.src :build/crypto/libcrypto.a)
                    (.. b.prefix :/lib/libcrypto.a))
            (b:move (b:join b.src :build/decrepit/libdecrepit.a)
                    (.. b.prefix :/lib/libdecrepit.a))
            (b:move (b:join b.src :include/openssl)
                    (.. b.prefix :/include/openssl)))}
