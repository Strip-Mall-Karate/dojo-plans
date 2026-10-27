;; python, ported from its plan.sh.
;; Python 3.15.2, the latest release on 2026-10-27. glibc needs it to build, so it is in the base set.
{:name :python
 :origin :karate
 :version :3.15.2
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Python-2.0]
 :description "Python is a programming language that lets you work quickly and integrate systems more effectively."
 :upstream_url "https://www.python.org"
 :source {:url "https://www.python.org/ftp/python/3.15.2/Python-3.15.2.tar.xz"
          :sha256 :8b5536d280142ecf6cdfe15d12a21ba1c65e300bbf7b28a8d0cdb849575797de
          :dirname :Python-3.15.2}
 :deps [:karate/bzip2
        :karate/expat
        :karate/gcc-libs
        :karate/gdbm
        :karate/glibc
        :karate/libffi
        :karate/ncurses
        :karate/openssl
        :karate/readline
        :karate/sqlite
        :karate/util-linux
        :karate/xz
        :karate/zlib]
 :build_deps [:karate/coreutils
              :karate/diffutils
              :karate/gcc
              :karate/linux-headers
              :karate/make
              :karate/pkg-config]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :interpreters [:bin/python :bin/python3 :bin/python3.15]
 :build (fn [b]
          (b:run [:./configure
                  (.. :--prefix= b.prefix)
                  :--enable-shared
                  :--enable-loadable-sqlite-extensions
                  :--with-system-expat
                  (.. :--with-openssl= (b:path_for :openssl))
                  :--with-ensurepip=install
                  ;; The test suite stays out of the package; its archive fixtures name /bin/bash.
                  :--disable-test-modules])
          (b:run [:make (.. :-j (tostring b.jobs))]))
 :check (fn [b]
          (b:run [:make :test]))
 :install (fn [b]
            (b.default.install b)
            (each [_ name (ipairs [:pip :pydoc :python :python-config])]
              (b:symlink (.. name :3) (.. b.prefix :/bin/ name)))
            (each [_ name (ipairs [:idle3 :idle3.15])]
              (b:remove (.. b.prefix :/bin/ name))))}
