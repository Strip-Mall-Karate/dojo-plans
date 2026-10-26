;; rngd, ported from its plan.sh.
{:name "rngd"
 :origin "karate"
 :version "5"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0"]
 :description "Check and feed random data from hardware device to kernel"
 :upstream_url "https://sourceforge.net/projects/gkernel/"
 :source {:url "http://downloads.sourceforge.net/sourceforge/gkernel/rng-tools-5.tar.gz" :sha256 "60a102b6603bbcce2da341470cad42eeaa9564a16b4490e7867026ca11a3078e" :dirname "rng-tools-5"}
 :deps ["karate/glibc"]
 :build_deps ["karate/gcc" "karate/make"]
 :bin_dirs ["bin" "sbin"]
 :svc {:run "rngd -f -r /dev/urandom" :user "root" :group "root"}}
