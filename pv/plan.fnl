;; pv, ported from its plan.sh.
{:name "pv"
 :origin "karate"
 :version "1.6.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["ARTISTIC 2.0"]
 :description "Pipe Viewer - is a terminal-based tool for monitoring the progress of data through a pipeline."
 :upstream_url "http://www.ivarch.com/programs/pv.shtml"
 :source {:url "https://www.ivarch.com/programs/sources/pv-1.6.0.tar.bz2" :sha256 "0ece824e0da27b384d11d1de371f20cafac465e038041adab57fcf4b5036ef8d"}
 :deps ["karate/glibc"]
 :build_deps ["karate/make" "karate/gcc"]
 :bin_dirs ["bin"]}
