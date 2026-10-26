;; libffi, ported from its plan.sh.
{:name "libffi"
 :origin "karate"
 :version "3.2.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :source {:url "ftp://sourceware.org/pub/libffi/libffi-3.2.1.tar.gz" :sha256 "d06ebb8e1d9a22d19e38d63fdb83954253f39bedc5d46232a05645685722ca37" :filename "libffi-3.2.1.tar.gz"}
 :deps ["karate/glibc" "karate/libtool"]
 :build_deps ["karate/coreutils" "karate/make" "karate/gcc"]
 :lib_dirs ["lib"]
 :include_dirs ["lib/libffi-3.2.1/include"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--disable-multi-os-directory"])
          (b:run ["make"]))}
