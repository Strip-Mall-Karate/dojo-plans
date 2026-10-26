;; qemu, ported from its plan.sh.
{:name "qemu"
 :origin "karate"
 :version "2.11.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0"]
 :description "QEMU is a generic and open source machine emulator and virtualizer."
 :upstream_url "http://www.qemu.org"
 :source {:url "http://wiki.qemu-project.org/download/qemu-2.11.1.tar.bz2" :sha256 "d9df2213ceed32e91dab7bc9dd19c1af83f91ba72c7aeef7605dfaaf81732ccb"}
 :deps ["karate/bzip2" "karate/curl" "karate/gcc-libs" "karate/glib" "karate/glibc" "karate/jemalloc" "karate/libaio" "karate/libcap-ng" "karate/lzo" "karate/ncurses" "karate/patch" "karate/pcre" "karate/pixman" "karate/python2" "karate/snappy" "karate/util-linux" "karate/vde2" "karate/zlib"]
 :build_deps ["karate/autoconf" "karate/automake" "karate/diffutils" "karate/gcc" "karate/libtool" "karate/make" "karate/m4" "karate/pkg-config"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :prepare (fn [b]
          (b:run ["patch" "-p1" "-i" (.. b.plan_dir "/glibc-2.27.patch")]))
 :build (fn [b]
          (b:mkdir (b:join b.src "build"))
          (b:env "CFLAGS" (.. (or (b:getenv "CFLAGS") "") " -fPIC"))
          (b:env "QEMU_CFLAGS" (or (b:getenv "CFLAGS") ""))
          (b:run ["../configure" (.. "--prefix=" b.prefix) "--target-list=x86_64-softmmu"] {:cwd "build"})
          (b:run ["make"] {:cwd "build"}))
 :install (fn [b]
          (b:run ["make" "install"] {:cwd "build"}))
 :strip (fn [b]
          nil)}
