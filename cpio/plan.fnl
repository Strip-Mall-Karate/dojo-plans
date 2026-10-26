;; cpio, ported from its plan.sh.
{:name "cpio"
 :origin "karate"
 :version "2.12"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-3.0"]
 :source {:url "http://ftp.gnu.org/gnu/cpio/cpio-2.12.tar.gz" :sha256 "08a35e92deb3c85d269a0059a27d4140a9667a6369459299d08c17f713a92e73"}
 :build_deps ["karate/make" "karate/gcc"]
 :bin_dirs ["bin"]}
