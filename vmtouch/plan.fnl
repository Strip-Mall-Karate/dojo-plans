;; vmtouch, ported from its plan.sh.
{:name "vmtouch"
 :origin "karate"
 :version "1.1.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["BSD-3-Clause"]
 :description "vmtouch is a tool for learning about and controlling the file system cache of unix and unix-like systems"
 :upstream_url "https://hoytech.com/vmtouch/"
 :source {:url "https://github.com/hoytech/vmtouch/archive/v1.1.0.tar.gz" :sha256 "1ba2a12aabed977894ce3a272b2fa8ed6ddfec7a720d7686e074f9e756104796"}
 :deps ["karate/glibc"]
 :build_deps ["karate/gcc" "karate/make" "karate/perl"]
 :bin_dirs ["bin"]
 :build (fn [b]
          (b:run ["make" (.. "PREFIX=" b.prefix)]))}
