;; zip, ported from its plan.sh.
{:name :zip
 :origin :karate
 :version :3.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:custom]
 :source {:url "http://downloads.sourceforge.net/infozip/zip30.tar.gz"
          :sha256 :f0e8bb1f9b7eb0b01285495a2699df3a4b766784c1765a8f1aeedf63c0806369
          :dirname :zip30}
 :deps [:karate/glibc]
 :build_deps [:karate/coreutils :karate/make :karate/gcc]
 :bin_dirs [:bin]
 :build (fn [b]
          (b:run [:make :-f :unix/Makefile (.. :prefix= b.prefix) :generic_gcc]))
 :install (fn [b]
            (b:run [:make
                    :-f
                    :unix/Makefile
                    (.. :prefix= b.prefix)
                    (.. :MANDIR= b.prefix :/share/man/man1)
                    :install]))}
