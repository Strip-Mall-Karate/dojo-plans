;; netcat, ported from its plan.sh.
{:name "netcat"
 :origin "karate"
 :version "0.7.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0"]
 :description "GNU rewrite of the OpenBSD netcat/nc package"
 :upstream_url "http://netcat.sourceforge.net/"
 :source {:url "http://downloads.sourceforge.net/sourceforge/netcat/netcat-0.7.1.tar.gz" :sha256 "30719c9a4ffbcf15676b8f528233ccc54ee6cba96cb4590975f5fd60c68a066f"}
 :deps ["karate/glibc"]
 :build_deps ["karate/gcc" "karate/make"]
 :bin_dirs ["bin"]}
