;; xz-musl, ported from its plan.sh.
;; xz-musl 5.8.4, the latest release on 2026-10-26: 5.2.4's source no longer downloads.
;; Built from the xz plan, with its own changes.
{:name :xz-musl
 :origin :karate
 :version :5.8.4
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:gpl2+ :lgpl2+]
 :description "XZ Utils is free general-purpose data compression software with a high compression ratio. XZ Utils were written for POSIX-like systems, but also work on some not-so-POSIX systems. XZ Utils are the successor to LZMA Utils."
 :upstream_url "http://tukaani.org/xz/"
 :source {:url "https://github.com/tukaani-project/xz/releases/download/v5.8.4/xz-5.8.4.tar.xz"
          :sha256 :4ce24038fd4221e0d13bc1a2de7a4db56e90b92b3bf75321f6c14be73f65de4b
          :dirname :xz-5.8.4}
 :deps [:karate/musl]
 :build_deps [:karate/coreutils
              :karate/diffutils
              :karate/patch
              :karate/make
              :karate/gcc
              :karate/sed]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]
 :prepare (fn [b]
            (var v-dynamic-linker "")
            (b:env :CC :musl-gcc)
            (b:log (.. "Setting CC=" (or (b:getenv :CC) "")))
            (set v-dynamic-linker
                 (.. (b:path_for :musl) :/lib/ld-musl-x86_64.so.1))
            (b:env :LDFLAGS
                   (.. (or (b:getenv :LDFLAGS) "") " -Wl,--dynamic-linker="
                       v-dynamic-linker)))
 :check (fn [b]
          (b:run [:make :check]))}
