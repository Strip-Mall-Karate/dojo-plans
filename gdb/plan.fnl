;; gdb, ported from its plan.sh.
{:name "gdb"
 :origin "karate"
 :version "8.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-3.0"]
 :description "GDB, the GNU Project debugger, allows you to see what is going on 'inside' another program while it executes -- or what another program was doing at the moment it crashed."
 :upstream_url "https://www.gnu.org/software/gdb/"
 :source {:url "http://ftp.gnu.org/gnu/gdb/gdb-8.1.tar.xz" :sha256 "af61a0263858e69c5dce51eab26662ff3d2ad9aa68da9583e8143b5426be4b34"}
 :deps ["karate/glibc" "karate/readline" "karate/zlib" "karate/xz" "karate/ncurses" "karate/expat" "karate/guile" "karate/bdwgc" "karate/python"]
 :build_deps ["karate/coreutils" "karate/pkg-config" "karate/diffutils" "karate/expect" "karate/dejagnu" "karate/patch" "karate/make" "karate/gcc" "karate/texinfo"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :prepare (fn [b]
          (b:env "CFLAGS" (.. (or (b:getenv "CFLAGS") "") " -O2 -fstack-protector-strong -Wformat -Werror=format-security "))
          (b:env "CXXFLAGS" (.. (or (b:getenv "CXXFLAGS") "") " -O2 -fstack-protector-strong -Wformat -Werror=format-security "))
          (b:env "CPPFLAGS" (.. (or (b:getenv "CPPFLAGS") "") " -Wdate-time"))
          (b:env "LDFLAGS" (.. (or (b:getenv "LDFLAGS") "") " -Wl,-Bsymbolic-functions -Wl,-z,relro"))
          (b:run ["patch" "-p1" "-i" (.. b.plan_dir "/fix-python37.patch")]))
 :build (fn [b]
          (b:run ["./configure" "--build=x86_64-linux-gnu" "--host=x86_64-linux-gnu" (.. "--prefix=" b.prefix) "--sysconfdir=/doj/svc/gdb/config" "--localstatedir=/doj/svc/gdb/var" (.. "--libexecdir=" b.prefix "/lib/gdb") "--enable-tui" "--disable-maintainer-mode" "--disable-dependency-tracking" "--disable-silent-rules" "--disable-gdbtk" "--disable-shared" (.. "--with-pkgversion=The Dojo Maintainers " b.version "/" b.release) "--with-system-readline" "--with-system-zlib" "--with-lzma" "--with-expat" "--with-guile" "--without-babeltrace" "--with-system-gdbinit=/doj/svc/gdb/config/gdb/gdbinit" "--with-python=python3"])
          (b:run ["make" "-j" (tostring b.jobs)]))
 :check (fn [b]
          (b:run ["make" "-j" (tostring b.jobs) "check"]))
 :install (fn [b]
          (b.default.install b)
          (b:remove (.. b.prefix "/lib/{libbfd,libopcodes}.a"))
          (b:remove (.. b.prefix "/include/{ansidecl,bfd,bfdlink,dis-asm,plugin-api,symcat}.h"))
          (b:remove (.. b.prefix "/share/info/bfd.info")))}
