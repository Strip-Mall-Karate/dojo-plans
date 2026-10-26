;; libvterm, ported from its plan.sh.
{:name "libvterm"
 :origin "karate"
 :version "0+bzr681"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "An abstract library implementation of a VT220/xterm/ECMA-48 terminal emulator."
 :upstream_url "http://www.leonerd.org.uk/code/libvterm/"
 :source {:url "http://www.leonerd.org.uk/code/libvterm/libvterm-0+bzr681.tar.gz" :sha256 "abea46d1b0b831dec2af5d582319635cece63d260f8298d9ccce7c1c2e62a6e8"}
 :deps ["karate/glibc"]
 :build_deps ["karate/gcc" "karate/libtool" "karate/make" "karate/perl"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["make" (.. "PREFIX=" b.prefix)]))
 :install (fn [b]
          (b:run ["make" "install" (.. "PREFIX=" b.prefix)]))}
