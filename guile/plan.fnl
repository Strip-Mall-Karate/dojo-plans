;; guile, ported from its plan.sh.
{:name :guile
 :origin :karate
 :version :2.0.12
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:LGPL-3.0]
 :description "An implementation of the Scheme programming language, used in many GNU programs as an extension language."
 :upstream_url "https://www.gnu.org/software/guile/"
 :source {:url "https://ftp.gnu.org/pub/gnu/guile/guile-2.0.12.tar.xz"
          :sha256 :de8187736f9b260f2fa776ed39b52cb74dd389ccf7039c042f0606270196b7e9}
 :deps [:karate/bdwgc
        :karate/gcc-libs
        :karate/glibc
        :karate/gmp
        :karate/libatomic_ops
        :karate/libffi
        :karate/libtool
        :karate/libunistring
        :karate/readline]
 :build_deps [:karate/diffutils :karate/gcc :karate/make :karate/pkg-config]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :prepare (fn [b]
            (b:env :LDFLAGS (.. "-lgcc_s " (or (b:getenv :LDFLAGS) ""))))
 :check (fn [b]
          (b:run [:make :check]))}
