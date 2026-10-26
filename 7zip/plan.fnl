;; 7zip, ported from its plan.sh.
{:name "7zip"
 :origin "karate"
 :version "16.02"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["LGPL-2.1" "unRAR restriction"]
 :description "7-Zip is a file archiver with a high compression ratio"
 :upstream_url "https://sourceforge.net/projects/p7zip/"
 :source {:url "https://downloads.sourceforge.net/project/p7zip/p7zip/16.02/p7zip_16.02_src_all.tar.bz2" :sha256 "5eb20ac0e2944f6cb9c2d51dd6c4518941c185347d4089ea89087ffdd6e2341f" :filename "p7zip_16.02_src_all.tar.bz2" :dirname "p7zip_16.02"}
 :deps ["karate/glibc" "karate/gcc-libs"]
 :build_deps ["karate/coreutils" "karate/make" "karate/gcc"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib/p7zip" "lib/p7zip/Codecs"]
 :build (fn [b]
          (var v-jobs (b:capture ["getconf" "_NPROCESSORS_ONLN"]))
          (if (b:exists (.. b.cache "/p7zip_16.02/makefile.machine"))
            (b:copy (.. b.cache "/p7zip_16.02/makefile.linux_amd64") (b:join (.. b.cache "/p7zip_16.02/makefile.machine") (: (.. b.cache "/p7zip_16.02/makefile.linux_amd64") :match "[^/]+$")))
            (b:copy (.. b.cache "/p7zip_16.02/makefile.linux_amd64") (.. b.cache "/p7zip_16.02/makefile.machine")))
          (b:run ["make" "-j" v-jobs "all2"]))
 :install (fn [b]
          (b:run ["make" (.. "DEST_HOME=" b.prefix) "install"]))}
