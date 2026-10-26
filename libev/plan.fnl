;; libev, ported from its plan.sh.
{:name "libev"
 :origin "karate"
 :version "4.23"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["BSD-2-Clause"]
 :description "A full-featured and high-performance (see benchmark) event loop that is loosely modelled after libevent."
 :upstream_url "http://software.schmorp.de/pkg/libev.html"
 :source {:url "http://dist.schmorp.de/libev/Attic/libev-4.23.tar.gz" :sha256 "c7fe743e0c3b50dd34bf222ebdba4e8acac031d41ce174f17890f8f84eeddd7a"}
 :deps ["karate/glibc"]
 :build_deps ["karate/cacerts" "karate/gcc" "karate/make"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]}
