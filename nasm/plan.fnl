;; nasm, ported from its plan.sh.
{:name "nasm"
 :origin "karate"
 :version "2.12.02"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["BSD-2-Clause"]
 :description "The Netwide Assembler, NASM, is an 80x86 and x86-64 assembler designed for portability and modularity."
 :upstream_url "http://www.nasm.us/"
 :source {:url "http://www.nasm.us/pub/nasm/releasebuilds/2.12.02/nasm-2.12.02.tar.bz2" :sha256 "00b0891c678c065446ca59bcee64719d0096d54d6886e6e472aeee2e170ae324"}
 :deps ["karate/glibc"]
 :build_deps ["karate/gcc" "karate/make"]
 :bin_dirs ["bin"]}
