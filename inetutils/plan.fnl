;; inetutils, ported from its plan.sh.
;; inetutils 2.8, the latest release on 2026-10-26.
{:name "inetutils"
 :origin "karate"
 :version "2.8"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["gplv3+"]
 :description "Inetutils is a collection of common network programs. It includes: an ftp client and server, a telnet client and server, an rsh client and server, an rlogin client and server, a tftp client and server, and much more..."
 :upstream_url "http://www.gnu.org/software/inetutils/"
 :source {:url "https://ftp.gnu.org/gnu/inetutils/inetutils-2.8.tar.gz" :sha256 "57b3cf4f77555992881e5ba2a09a63b05aa2c56342a60ed4305b5f45938390b5"}
 :deps ["karate/glibc" "karate/libcap" "karate/ncurses"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/sed" "karate/grep"]
 :bin_dirs ["bin"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--disable-logger" "--disable-whois" "--disable-rcp" "--disable-rexec" "--disable-rlogin" "--disable-rsh" "--disable-servers"])
          (b:run ["make"]))
 :install (fn [b]
          (b.default.install b)
          (b:remove (.. b.prefix "/libexec")))}
