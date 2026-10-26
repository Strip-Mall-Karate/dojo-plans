;; qemu, ported from its plan.sh.
;; qemu 11.1.2, the latest release on 2026-10-26: 2.11.1's source no longer downloads.
{:name "qemu"
 :origin "karate"
 :version "11.1.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0"]
 :description "QEMU is a generic and open source machine emulator and virtualizer."
 :upstream_url "http://www.qemu.org"
 :source {:url "https://download.qemu.org/qemu-11.1.2.tar.xz" :sha256 "731b5681e4bb18be313231579b8efd0296c5b015fa36dc533874b639ba838016"}
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
