;; libpipeline, ported from its plan.sh.
{:name :libpipeline
 :origin :karate
 :version :1.4.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-3.0]
 :description "libpipeline is a C library for manipulating pipelines of subprocesses in a flexible and convenient way."
 :upstream_url "http://libpipeline.nongnu.org/"
 :source {:url "http://download.savannah.gnu.org/releases/libpipeline/libpipeline-1.4.1.tar.gz"
          :sha256 :da46d7b20163aadb9db2faae483f734e9096a7550c84b94029abeab62dd1b9ee}
 :deps [:karate/glibc]
 :build_deps [:karate/gcc :karate/coreutils :karate/make :karate/diffutils]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :prepare (fn [b]
            (b:env :CFLAGS
                   (.. (or (b:getenv :CFLAGS) "")
                       " -O2 -fstack-protector-strong -Wformat -Werror=format-security "))
            (b:env :CXXFLAGS
                   (.. (or (b:getenv :CXXFLAGS) "")
                       " -O2 -fstack-protector-strong -Wformat -Werror=format-security "))
            (b:env :CPPFLAGS (.. (or (b:getenv :CPPFLAGS) "") " -Wdate-time"))
            (b:env :LDFLAGS
                   (.. (or (b:getenv :LDFLAGS) "")
                       " -Wl,-Bsymbolic-functions -Wl,-z,relro")))
 :build (fn [b]
          (b:run [:./configure
                  (.. :--prefix= b.prefix)
                  :--disable-silent-rules
                  :--enable-largefile
                  :--enable-threads=posix])
          (b:run [:make :-j (tostring b.jobs)]))
 :check (fn [b]
          (b:run [:make :check]))
 :install (fn [b]
            (b:run [:make :install])
            (b:run [:make :installcheck]))}
