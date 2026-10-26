;; linux-pam, ported from its plan.sh.
{:name "linux-pam"
 :origin "karate"
 :version "1.3.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["BSD-3-Clause" "GPL"]
 :description "Linux-PAM is a free implementation of the following DCE-RFC from Sunsoft."
 :upstream_url "http://www.linux-pam.org/"
 :source {:url "http://www.linux-pam.org/library/Linux-PAM-1.3.0.tar.bz2" :sha256 "241aed1ef522f66ed672719ecf2205ec513fd0075ed80cda8e086a5b1a01d1bb" :filename "linux-pam-1.3.0.tar.bz2" :dirname "Linux-PAM-1.3.0"}
 :deps ["karate/glibc"]
 :build_deps ["karate/coreutils" "karate/gcc" "karate/make"]
 :bin_dirs ["sbin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]}
