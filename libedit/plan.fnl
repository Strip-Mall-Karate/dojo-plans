;; libedit, ported from its plan.sh.
;; libedit 3.1.20260512, the latest release on 2026-10-26: 3.1.20150325's source no longer downloads.
{:name :libedit
 :origin :karate
 :version :3.1.20260512
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:bsd]
 :source {:url "https://deb.debian.org/debian/pool/main/libe/libedit/libedit_3.1-20260512.orig.tar.gz"
          :sha256 :432d5e7ea8b0116dd39f2eca7bc11d0eed77faa6b77ea526ace89907c23ea4a0
          :filename :libedit-20260512-3.1.tar.gz
          :dirname :libedit-20260512-3.1}
 :deps [:karate/glibc :karate/ncurses]
 :build_deps [:karate/gcc :karate/make :karate/coreutils]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :build (fn [b]
          (b:run [:./configure :--enable-widec (.. :--prefix= b.prefix)]))}
