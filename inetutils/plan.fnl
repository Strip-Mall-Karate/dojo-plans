;; inetutils, ported from its plan.sh.
{:name "inetutils"
 :origin "karate"
 :version "1.9.4"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["gplv3+"]
 :description "Inetutils is a collection of common network programs. It includes: an ftp client and server, a telnet client and server, an rsh client and server, an rlogin client and server, a tftp client and server, and much more..."
 :upstream_url "http://www.gnu.org/software/inetutils/"
 :source {:url "http://ftp.gnu.org/gnu/inetutils/inetutils-1.9.4.tar.xz" :sha256 "849d96f136effdef69548a940e3e0ec0624fc0c81265296987986a0dd36ded37"}
 :deps ["karate/glibc" "karate/libcap" "karate/ncurses"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/sed" "karate/grep"]
 :bin_dirs ["bin"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--disable-logger" "--disable-whois" "--disable-rcp" "--disable-rexec" "--disable-rlogin" "--disable-rsh" "--disable-servers"])
          (b:run ["make"]))
 :install (fn [b]
          (b.default.install b)
          (b:remove (.. b.prefix "/libexec")))}
