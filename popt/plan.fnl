;; popt, ported from its plan.sh.
{:name "popt"
 :origin "karate"
 :version "1.16"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "Popt is a C library for parsing command line parameters"
 :upstream_url "http://rpm5.org"
 :source {:url "ftp://anduin.linuxfromscratch.org/BLFS/popt/popt-1.16.tar.gz" :sha256 "e728ed296fe9f069a0e005003c3d6b2dde3d9cad453422a10d6558616d304cc8"}
 :deps ["karate/glibc"]
 :build_deps ["karate/gcc" "karate/make"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]}
