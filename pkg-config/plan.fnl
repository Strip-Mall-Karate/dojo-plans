;; pkg-config, ported from its plan.sh.
;; pkg-config 0.29.2, the latest release on 2026-10-26.
{:name "pkg-config"
 :origin "karate"
 :version "0.29.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["gplv2+"]
 :description "pkg-config is a helper tool used when compiling applications and libraries. It helps you insert the correct compiler options on the command line so an application can use a call to pkg-config for instance, rather than hard-coding values on where to find glib (or other libraries)."
 :upstream_url "http://pkgconfig.freedesktop.org/wiki/"
 :source {:url "https://pkgconfig.freedesktop.org/releases/pkg-config-0.29.2.tar.gz" :sha256 "6fc69c01688c9458a57eb9a1664c9aba372ccda420a02bf4429fe610e7e7d591"}
 :deps ["karate/glibc"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc"]
 :bin_dirs ["bin"]
 :prepare (fn [b]
          (b.default.prepare b)
          ;; Plans that build with it find its m4 macros: aclocal reads ACLOCAL_PATH.
          (b:buildtime_env_push "ACLOCAL_PATH" (.. b.prefix "/share/aclocal")))
 :build (fn [b]
          ;; The glib 0.29.2 bundles names a struct member bool, a keyword in C23, gcc 15's and
          ;; 16's default.
          (b:env "CFLAGS" (.. (or (b:getenv "CFLAGS") "") " -std=gnu17"))
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--with-internal-glib" "--disable-host-tool"])
          (b:run ["make"]))
 :check (fn [b]
          (b:run ["make" "check"]))}
