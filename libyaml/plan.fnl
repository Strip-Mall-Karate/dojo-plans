;; libyaml, ported from its plan.sh.
{:name "libyaml"
 :origin "karate"
 :version "0.1.6"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["mit"]
 :source {:url "http://pyyaml.org/download/libyaml/yaml-0.1.6.tar.gz" :sha256 "7da6971b4bd08a986dd2a61353bc422362bd0edcc67d7ebaac68c95f74182749" :filename "yaml-0.1.6.tar.gz" :dirname "yaml-0.1.6"}
 :deps ["karate/glibc"]
 :build_deps ["karate/coreutils" "karate/make" "karate/gcc"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]}
