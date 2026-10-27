;; libscrypt, ported from its plan.sh.
{:name :libscrypt
 :origin :karate
 :version :1.21
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:BSD-2-Clause]
 :description "An implementation of Colin Percival's scrypt hash"
 :upstream_url "http://www.lolware.net/libscrypt.html"
 :source {:url "https://github.com/technion/libscrypt/archive/v1.21.tar.gz"
          :sha256 :68e377e79745c10d489b759b970e52d819dbb80dd8ca61f8c975185df3f457d3}
 :deps [:karate/glibc]
 :build_deps [:karate/gcc :karate/make]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :build (fn [b]
          (b:env :CFLAGS
                 (.. (or (b:getenv :CFLAGS) "")
                     " -O2 -Wall -g -D_FORTIFY_SOURCE=2 -fstack-protector -fPIC"))
          (b:run [:make]))
 :check (fn [b]
          (b:run [:make :check]))
 :install (fn [b]
            (b:run [:make :install] {:env {:PREFIX b.prefix}}))}
