;; libossp-uuid, ported from its plan.sh.
{:name "libossp-uuid"
 :origin "karate"
 :version "1.6.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "OSSP uuid is a ISO-C:1999 application programming interface (API) and corresponding command line interface (CLI) for the generation of DCE 1.1"
 :upstream_url "http://www.ossp.org/pkg/lib/uuid/"
 :source {:url "https://www.mirrorservice.org/sites/ftp.ossp.org/pkg/lib/uuid/uuid-1.6.2.tar.gz" :sha256 "11a615225baa5f8bb686824423f50e4427acd3f70d394765bdff32801f0fd5b0" :dirname "uuid-1.6.2"}
 :deps ["karate/glibc"]
 :build_deps ["karate/coreutils" "karate/make" "karate/gcc" "karate/binutils"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]}
