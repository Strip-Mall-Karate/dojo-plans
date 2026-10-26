;; gdb7, ported from its plan.sh.
{:name "gdb7"
 :origin "karate"
 :version "7.12"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-3.0"]
 :description "GDB, the GNU Project debugger, allows you to see what is going on 'inside' another program while it executes -- or what another program was doing at the moment it crashed."
 :upstream_url "https://www.gnu.org/software/gdb/"
 :source {:url "http://ftp.gnu.org/gnu/gdb/gdb-7.12.tar.xz" :sha256 "834ff3c5948b30718343ea57b11cbc3235d7995c6a4f3a5cecec8c8114164f94" :filename "gdb-7.12.tar.xz" :dirname "gdb-7.12"}
 :deps ["karate/glibc" "karate/readline" "karate/zlib" "karate/xz" "karate/ncurses" "karate/expat" "karate/guile" "karate/bdwgc" "karate/python36"]
 :build_deps ["karate/coreutils" "karate/pkg-config" "karate/diffutils" "karate/expect" "karate/dejagnu" "karate/patch" "karate/make" "karate/gcc" "karate/texinfo"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :prepare (fn [b]
          (b:env "CFLAGS" (.. (or (b:getenv "CFLAGS") "") " -O2 -fstack-protector-strong -Wformat -Werror=format-security "))
          (b:env "CXXFLAGS" (.. (or (b:getenv "CXXFLAGS") "") " -O2 -fstack-protector-strong -Wformat -Werror=format-security -fpermissive "))
          (b:env "CPPFLAGS" (.. (or (b:getenv "CPPFLAGS") "") " -Wdate-time"))
          (b:env "LDFLAGS" (.. (or (b:getenv "LDFLAGS") "") " -Wl,-Bsymbolic-functions -Wl,-z,relro")))
 :build (fn [b]
          (b:run ["./configure" "--build=x86_64-linux-gnu" "--host=x86_64-linux-gnu" (.. "--prefix=" b.prefix) "--sysconfdir=/doj/svc/gdb7/config" "--localstatedir=/doj/svc/gdb7/var" (.. "--libexecdir=" b.prefix "/lib/gdb") "--enable-tui" "--disable-maintainer-mode" "--disable-dependency-tracking" "--disable-silent-rules" "--disable-gdbtk" "--disable-shared" (.. "--with-pkgversion=The Dojo Maintainers " b.version "/" b.release) "--with-system-readline" "--with-system-zlib" "--with-lzma" "--with-expat" "--with-guile" "--without-babeltrace" "--with-system-gdbinit=/doj/svc/gdb7/config/gdb/gdbinit" "--with-python=python3"])
          (b:run ["make" "-j" (tostring b.jobs)]))
 :check (fn [b]
          (b:run ["make" "-j" (tostring b.jobs) "check"]))
 :install (fn [b]
          (b.default.install b)
          (b:remove (.. b.prefix "/lib/{libbfd,libopcodes}.a"))
          (b:remove (.. b.prefix "/include/{ansidecl,bfd,bfdlink,dis-asm,plugin-api,symcat}.h"))
          (b:remove (.. b.prefix "/share/info/bfd.info")))}
