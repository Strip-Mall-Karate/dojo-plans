;; galera, ported from its plan.sh.
{:name "galera"
 :origin "karate"
 :version "25.3.19"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0"]
 :description "Galera WSREP plugin"
 :upstream_url "https://github.com/codership/galera"
 :source {:url "http://github.com/codership/galera/archive/release_25.3.19.tar.gz" :sha256 "068b074ca5a5c2a5a3f799422650e7c5e5c9012ddfa1c18c30feab7f9aa9611d" :dirname "galera-release_25.3.19"}
 :build_deps ["karate/scons" "karate/python2" "karate/gcc" "karate/boost" "karate/check" "karate/openssl"]
 :lib_dirs ["lib"]
 :build (fn [b]
          (b:run ["scons" "strict_build_flags=0" "tests=0"]))
 :install (fn [b]
          (b:mkdir (.. b.prefix "/lib"))
          (if (b:exists (.. b.prefix "/lib"))
            (b:copy (b:join b.src "libgalera_smm.so") (b:join (.. b.prefix "/lib") (: (b:join b.src "libgalera_smm.so") :match "[^/]+$")))
            (b:copy (b:join b.src "libgalera_smm.so") (.. b.prefix "/lib"))))}
