;; nettle, ported from its plan.sh.
{:name "nettle"
 :origin "karate"
 :version "3.4.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["LGPL-3.0" "GPL-2.0" "GPL-3.0"]
 :description "a low-level cryptographic library"
 :upstream_url "https://www.lysator.liu.se/~nisse/nettle/"
 :source {:url "https://ftp.gnu.org/gnu/nettle/nettle-3.4.1.tar.gz" :sha256 "f941cf1535cd5d1819be5ccae5babef01f6db611f9b5a777bae9c7604b8a92ad"}
 :deps ["karate/glibc" "karate/gmp"]
 :build_deps ["karate/diffutils" "karate/gcc" "karate/m4" "karate/make" "karate/pkg-config"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :check (fn [b]
          (b:env "LD_RUN_PATH" (.. (or (b:getenv "LD_RUN_PATH") "") ":" (b:path_for "karate/gcc") "/lib"))
          (b:run ["make" "check"]))}
