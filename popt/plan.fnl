;; popt, ported from its plan.sh.
;; popt 1.19, the latest release on 2026-10-26: 1.16's source no longer downloads.
{:name "popt"
 :origin "karate"
 :version "1.19"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "Popt is a C library for parsing command line parameters"
 :upstream_url "http://rpm5.org"
 :source {:url "https://ftp.osuosl.org/pub/rpm/popt/releases/popt-1.x/popt-1.19.tar.gz" :sha256 "c25a4838fc8e4c1c8aacb8bd620edb3084a3d63bf8987fdad3ca2758c63240f9"}
 :deps ["karate/glibc"]
 :build_deps ["karate/gcc" "karate/make"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]}
