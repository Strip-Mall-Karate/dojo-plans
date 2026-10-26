;; gdbm, ported from its plan.sh.
{:name "gdbm"
 :origin "karate"
 :version "1.17"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["gplv3+"]
 :description "GNU dbm is a set of database routines that use extensible hashing. It works similar to the standard UNIX dbm routines."
 :upstream_url "http://www.gnu.org/software/gdbm/gdbm.html"
 :source {:url "http://ftp.gnu.org/gnu/gdbm/gdbm-1.17.tar.gz" :sha256 "7cd8cc2e35b1aaede6084ea57cc9447752f498daaea854100a4bad567614977d"}
 :deps ["karate/glibc"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--enable-libgdbm-compat"])
          (b:run ["make"]))
 :check (fn [b]
          (b:run ["make" "check"]))
 :install (fn [b]
          (b.default.install b)
          (b:mkdir (.. b.prefix "/include/gdbm"))
          (b:chmod (.. b.prefix "/include/gdbm") "755")
          (b:remove (.. b.prefix "/include/gdbm/gdbm.h"))
          (b:symlink "../gdbm.h" (.. b.prefix "/include/gdbm/gdbm.h"))
          (b:remove (.. b.prefix "/include/gdbm/ndbm.h"))
          (b:symlink "../ndbm.h" (.. b.prefix "/include/gdbm/ndbm.h"))
          (b:remove (.. b.prefix "/include/gdbm/dbm.h"))
          (b:symlink "../dbm.h" (.. b.prefix "/include/gdbm/dbm.h")))}
