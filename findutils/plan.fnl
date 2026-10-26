;; findutils, ported from its plan.sh.
{:name "findutils"
 :origin "karate"
 :version "4.6.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["gplv3+"]
 :description "The GNU Find Utilities are the basic directory searching utilities of the GNU operating system. These programs are typically used in conjunction with other programs to provide modular and powerful directory search and file locating capabilities to other commands."
 :upstream_url "http://www.gnu.org/software/findutils"
 :source {:url "http://ftp.gnu.org/gnu/findutils/findutils-4.6.0.tar.gz" :sha256 "ded4c9f73731cd48fec3b6bdaccce896473b6d8e337e9612e16cf1431bb1169d"}
 :deps ["karate/glibc"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/sed"]
 :bin_dirs ["bin"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--localstatedir=/doj/svc/findutils/var/locate"])
          (b:run ["make"]))
 :check (fn [b]
          (b:run ["make" "check"]))}
