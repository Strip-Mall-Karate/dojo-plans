;; util-linux, ported from its plan.sh.
{:name "util-linux"
 :origin "karate"
 :version "2.32"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPLv2"]
 :description "Miscellaneous system utilities for Linux"
 :upstream_url "https://www.kernel.org/pub/linux/utils/util-linux"
 :source {:url "https://www.kernel.org/pub/linux/utils/util-linux/v2.32/util-linux-2.32.tar.xz" :sha256 "6c7397abc764e32e8159c2e96042874a190303e77adceb4ac5bd502a272a4734"}
 :deps ["karate/glibc" "karate/zlib" "karate/ncurses"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/sed"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) (.. "--sbindir=" b.prefix "/bin") "--localstatedir=/doj/svc/util-linux/var/run" "--without-python" "--without-slang" "--without-systemd" "--without-systemdsystemunitdir" "--disable-use-tty-group" "--disable-chfn-chsh" "--disable-login" "--disable-nologin" "--disable-su" "--disable-setpriv" "--disable-runuser" "--disable-pylibmount"])
          (b:run ["make"]))
 :install (fn [b]
          (b:run ["make" "install" (.. "usrsbin_execdir=" b.prefix "/bin")]))}
