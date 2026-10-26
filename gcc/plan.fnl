;; gcc, ported from its plan.sh.
;; gcc 16.2.0, the latest release on 2026-10-26.
(var v-bash "")
(var v-binutils "")
(var v-build-cflags "")
(var v-dynamic-linker "")
(var v-glibc "")
(var v-headers "")
(var v-target-ldflags "")
(fn v-wrap-binary [b a1]
  (var v-bin "")
  (set v-bin (.. b.prefix "/bin/" a1))
  (b:log (.. "Adding wrapper " v-bin " to " v-bin ".real"))
  (if (b:exists (.. v-bin ".real"))
    (b:move v-bin (b:join (.. v-bin ".real") (: v-bin :match "[^/]+$")))
    (b:move v-bin (.. v-bin ".real")))
  (b:write v-bin (let [text (b:read (.. b.plan_dir "/cc-wrapper.sh")) ends (= (text:sub -1) "\n") lines [] out []]
    (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
    (each [n l (ipairs lines)]
      (var line l) (var deleted false) (local after [])
      (when (not deleted) (set line (pick-values 1 (string.gsub line "@shell@" (pick-values 1 (: v-bash :gsub "%%" "%%%%"))))))
      (when (not deleted) (set line (pick-values 1 (string.gsub line "@glibc@" (pick-values 1 (: v-glibc :gsub "%%" "%%%%"))))))
      (when (not deleted) (set line (pick-values 1 (string.gsub line "@binutils@" (pick-values 1 (: v-binutils :gsub "%%" "%%%%"))))))
      (when (not deleted) (set line (pick-values 1 (string.gsub line "@gcc@" (pick-values 1 (: b.prefix :gsub "%%" "%%%%"))))))
      (when (not deleted) (set line (pick-values 1 (string.gsub line "@dynamic_linker@" (pick-values 1 (: v-dynamic-linker :gsub "%%" "%%%%"))))))
      (when (not deleted) (set line (pick-values 1 (string.gsub line "@program@" (.. (pick-values 1 (: v-bin :gsub "%%" "%%%%")) ".real")))))
      (when (not deleted) (table.insert out line))
      (each [_ x (ipairs after)] (table.insert out x)))
    (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" ""))))
  (b:chmod v-bin "755"))
{:name "gcc"
 :origin "karate"
 :version "16.2.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0"]
 :description "The GNU Compiler Collection (GCC) is a compiler system produced by the GNU Project supporting various programming languages. GCC is a key component of the GNU toolchain and the standard compiler for most Unix-like operating systems."
 :upstream_url "https://gcc.gnu.org/"
 :source {:url "https://ftp.gnu.org/gnu/gcc/gcc-16.2.0/gcc-16.2.0.tar.xz" :sha256 "e6738e29597f733270731aa90600f37ffdc045079dfc27ec7e8192cc81085c3e"}
 :deps ["karate/glibc" "karate/zlib" "karate/gmp" "karate/mpfr" "karate/libmpc" "karate/binutils"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/file" "karate/make" "karate/gcc" "karate/gawk" "karate/m4" "karate/texinfo" "karate/perl" "karate/inetutils" "karate/expect" "karate/dejagnu"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :prepare (fn [b]
          (var v-orig-cflags "")
          (set v-glibc (b:path_for "glibc"))
          (set v-binutils (b:path_for "binutils"))
          (set v-headers (.. v-glibc "/include"))
          (set v-dynamic-linker (.. (b:path_for "glibc") "/lib/ld-linux-x86-64.so.2"))
          (b:env "LDFLAGS" (.. (or (b:getenv "LDFLAGS") "") " -Wl,-rpath=" (or (b:getenv "LD_RUN_PATH") "") ",--enable-new-dtags"))
          (b:env "LDFLAGS" (.. (or (b:getenv "LDFLAGS") "") " -Wl,--dynamic-linker=" v-dynamic-linker))
          (b:log (.. "Updating LDFLAGS=" (or (b:getenv "LDFLAGS") "")))
          (set v-orig-cflags (or (b:getenv "CFLAGS") ""))
          (b:env "CFLAGS" "")
          (each [_ v-include (ipairs [v-orig-cflags])]
            (when (not (string.find v-include (pick-values 1 (: v-glibc :gsub "[%^%$%(%)%%%.%[%]%*%+%-%?]" "%%%0"))))
            (b:env "CFLAGS" (.. (or (b:getenv "CFLAGS") "") " " v-include))))
          (b:log (.. "Updating CFLAGS=" (or (b:getenv "CFLAGS") "")))
          (b:env "CXXFLAGS" (or (b:getenv "CFLAGS") ""))
          (b:log (.. "Setting CXXFLAGS=" (or (b:getenv "CXXFLAGS") "")))
          (b:env "CPPFLAGS" (or (b:getenv "CFLAGS") ""))
          (b:log (.. "Setting CPPFLAGS=" (or (b:getenv "CPPFLAGS") "")))
          (var v-cpath (.. (b:path_for "zlib") "/include"))
          (b:env "CPATH" v-cpath)
          (b:log (.. "Setting CPATH=" v-cpath))
          (var v-library-path (.. (b:path_for "zlib") "/lib"))
          (b:env "LIBRARY_PATH" v-library-path)
          (b:log (.. "Setting LIBRARY_PATH=" v-library-path))
          (set v-bash "/bin/bash")
          (b:run ["patch" "-p1" "-i" (.. b.plan_dir "/no-sys-dirs.patch")])
          (let [text (b:read (b:join b.src "gcc/configure")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line "glibc_header_dir=/usr/include" (.. "glibc_header_dir=" (pick-values 1 (: v-headers :gsub "%%" "%%%%"))) 1))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join b.src "gcc/configure") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" ""))))
          (b:log "Fixing the GLIBC_DYNAMIC_LINKER and UCLIBC_DYNAMIC_LINKER macros")
          ;; Each header that names LIBC_DYNAMIC_LINKER: the dynamic linker's path is glibc's.
          (let [config (b:join b.src "gcc/config")
                headers (b:glob config "*-gnu.h")
                glibc (pick-values 1 (v-glibc:gsub "%%" "%%%%"))]
            (each [_ d (ipairs (b:glob config "*"))]
              (when (b:exists (b:join d "."))
                (each [_ h (ipairs (b:glob d "*.h"))] (table.insert headers h))))
            (each [_ header (ipairs headers)]
              (let [text (b:read header)]
                (when (text:find "LIBC_DYNAMIC_LINKER" 1 true)
                  (b:log (.. "  Fixing " header))
                  (let [ends (= (text:sub -1) "\n") out []]
                    (each [line (string.gmatch (if ends text (.. text "\n")) "(.-)\n")]
                      (let [linked (pick-values 1 (line:gsub "define[ \t]*([UCG]+)LIBC_DYNAMIC_LINKER(%d*)[ \t]\"([^\\\"]+)\"$"
                                                             (.. "define %1LIBC_DYNAMIC_LINKER%2 \"" glibc "%3\"")))]
                        (table.insert out (pick-values 1 (linked:gsub "/lib64/ld%-linux%-" "/lib/ld-linux-")))))
                    (b:write header (.. (table.concat out "\n") (if ends "\n" ""))))))))
          (let [text (b:read (b:join b.src "gcc/config/i386/t-linux64")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (when (string.find line "m64=") (set line (pick-values 1 (string.gsub line "lib64" "lib" 1)))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join b.src "gcc/config/i386/t-linux64") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" ""))))
          ;; Each file under the source naming /usr/bin/file names file. In gcc 16.2.0 those are
          ;; the configure scripts and libtool's files; reading all of gcc's sources holds more
          ;; than a plan may.
          (each [_ name (ipairs ["configure" "configure.tgt" "ltmain.sh" "libtool.m4"])]
            (each [_ f (ipairs (b:find b.src name))]
              (let [(fixed n) (: (b:read f) :gsub "/usr/bin/file" "file")]
                (when (> n 0) (b:write f fixed)))))
          (set v-build-cflags "-O2")
          (set v-build-cflags (.. v-build-cflags " -I" v-headers))
          (set v-build-cflags (.. v-build-cflags " -B" v-glibc "/lib/"))
          (set v-build-cflags (.. v-build-cflags " -idirafter"))
          (set v-build-cflags (.. v-build-cflags " " v-headers))
          (set v-build-cflags (.. v-build-cflags " -idirafter"))
          (set v-build-cflags (.. v-build-cflags " " b.prefix "/lib/gcc/*/*/include-fixed"))
          (set v-build-cflags (.. v-build-cflags " -Wl,-L" v-glibc "/lib"))
          (set v-build-cflags (.. v-build-cflags " -Wl,-rpath"))
          (set v-build-cflags (.. v-build-cflags " -Wl," v-glibc "/lib"))
          (set v-build-cflags (.. v-build-cflags " -Wl,-L" v-glibc "/lib"))
          (set v-build-cflags (.. v-build-cflags " -Wl,-dynamic-linker"))
          (set v-build-cflags (.. v-build-cflags " -Wl," v-dynamic-linker))
          (set v-target-ldflags (.. "-Wl,-L" v-glibc "/lib"))
          (set v-target-ldflags (.. v-target-ldflags " -Wl,-rpath"))
          (set v-target-ldflags (.. v-target-ldflags " -Wl," v-glibc "/lib"))
          (set v-target-ldflags (.. v-target-ldflags " -Wl,-L" v-glibc "/lib"))
          (set v-target-ldflags (.. v-target-ldflags " -Wl,-dynamic-linker"))
          (set v-target-ldflags (.. v-target-ldflags " -Wl," v-dynamic-linker))
          (set v-target-ldflags (.. v-target-ldflags " -Wl,-L" v-glibc "/lib"))
          (set v-target-ldflags (.. v-target-ldflags " -Wl,-rpath"))
          (set v-target-ldflags (.. v-target-ldflags " -Wl," v-glibc "/lib"))
          (set v-target-ldflags (.. v-target-ldflags " -Wl,-L" v-glibc "/lib"))
          (set v-target-ldflags (.. v-target-ldflags " -Wl,-dynamic-linker"))
          (set v-target-ldflags (.. v-target-ldflags " -Wl," v-dynamic-linker)))
 :build (fn [b]
          (b:remove (b:join b.src (.. "../" b.name "-build")))
          (b:mkdir (b:join b.src (.. "../" b.name "-build")))
          (b:run [(.. "../" (.. b.name "-" b.version) "/configure") (.. "--prefix=" b.prefix) (.. "--with-gmp=" (b:path_for "gmp")) (.. "--with-mpfr=" (b:path_for "mpfr")) (.. "--with-mpc=" (b:path_for "libmpc")) (.. "--with-native-system-header-dir=" v-headers) "--enable-languages=c,c++,fortran" "--enable-lto" "--enable-plugin" "--enable-shared" "--enable-threads=posix" "--enable-install-libiberty" "--enable-vtable-verify" "--disable-werror" "--disable-multilib" "--with-system-zlib" "--disable-libstdcxx-pch"] {:cwd (.. "../" b.name "-build") :env {"SED" "sed" "LD" (.. (b:path_for "binutils") "/bin/ld") "AS" (.. (b:path_for "binutils") "/bin/as")}})
          (let [text (b:read (b:join (b:join b.src (.. "../" b.name "-build")) "Makefile")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (when (string.find line "TOPLEVEL_CONFIGURE_ARGUMENTS=") (set deleted true)))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join (b:join b.src (.. "../" b.name "-build")) "Makefile") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" ""))))
          (b:run ["make" (.. "-j" (tostring b.jobs)) (.. "NATIVE_SYSTEM_HEADER_DIR=" v-headers) (.. "SYSTEM_HEADER_DIR=" v-headers) (.. "CFLAGS_FOR_BUILD=" v-build-cflags) (.. "CXXFLAGS_FOR_BUILD=" v-build-cflags) (.. "CFLAGS_FOR_TARGET=" v-build-cflags) (.. "CXXFLAGS_FOR_TARGET=" v-build-cflags) (.. "FLAGS_FOR_TARGET=" v-build-cflags) (.. "LDFLAGS_FOR_BUILD=" v-build-cflags) (.. "LDFLAGS_FOR_TARGET=" v-target-ldflags) (.. "BOOT_CFLAGS=" v-build-cflags) (.. "BOOT_LDFLAGS=" v-build-cflags) "LIMITS_H_TEST=true" "profiledbootstrap"] {:cwd (.. "../" b.name "-build")}))
 :check (fn [b]
          ;; The plan raised the stack limit to 32 MiB for one test set that exhausts it. A
          ;; plan cannot set a limit; those tests' failures are tolerated, as all are here.
          (b:unsetenv "CPATH")
          (b:unsetenv "LIBRARY_PATH")
          (b:env "LIBRARY_PATH" (or (b:getenv "LD_RUN_PATH") ""))
          (b:run ["make" "-k" "check"] {:cwd (.. "../" b.name "-build") :check false})
          (b:unsetenv "LIBRARY_PATH")
          (b:log "Displaying Test Summary")
          (b:run [(.. "../" (.. b.name "-" b.version) "/contrib/test_summary")] {:cwd (.. "../" b.name "-build")}))
 :install (fn [b]
          (b:mkdir (.. b.prefix "/lib"))
          (let [link (if (b:exists (b:join (.. b.prefix "/lib64") ".")) (b:join (.. b.prefix "/lib64") "lib") (.. b.prefix "/lib64"))]
            (b:symlink "lib" link))
          (b:run ["make" "install"] {:cwd (.. "../" b.name "-build")})
          (b:copy (b:join (b:join b.src (.. "../" b.name "-build")) "libiberty/pic/libiberty.a") (b:join (.. b.prefix "/lib") (: (b:join (b:join b.src (.. "../" b.name "-build")) "libiberty/pic/libiberty.a") :match "[^/]+$")))
          (b:chmod (b:join (.. b.prefix "/lib") (: (b:join (b:join b.src (.. "../" b.name "-build")) "libiberty/pic/libiberty.a") :match "[^/]+$")) "644")
          (b:copy (b:join (b:join b.src (.. "../" b.name "-build")) (.. "../" (.. b.name "-" b.version) "/COPYING.RUNTIME")) (.. b.prefix "/share/licenses/RUNTIME.LIBRARY.EXCEPTION"))
          (b:chmod (.. b.prefix "/share/licenses/RUNTIME.LIBRARY.EXCEPTION") "644")
          ;; Each hard link of gcc made a symbolic one.
          (let [gcc (b:read (.. b.prefix "/bin/gcc"))]
            (each [_ bin (ipairs (b:glob (.. b.prefix "/bin") "*-gcc*"))]
              (when (= gcc (b:read bin))
                (b:remove bin)
                (b:symlink "gcc" bin))))
          ;; Each hard link of g++ made a symbolic one.
          (let [gxx (b:read (.. b.prefix "/bin/g++"))
                bins [(.. b.prefix "/bin/c++")]]
            (each [_ pattern (ipairs ["*-c++*" "*-g++*"])]
              (each [_ bin (ipairs (b:glob (.. b.prefix "/bin") pattern))] (table.insert bins bin)))
            (each [_ bin (ipairs bins)]
              (when (and (b:exists bin) (= gxx (b:read bin)))
                (b:remove bin)
                (b:symlink "g++" bin))))
          (let [link (if (b:exists (b:join (.. b.prefix "/bin/cc") ".")) (b:join (.. b.prefix "/bin/cc") "gcc") (.. b.prefix "/bin/cc"))]
            (b:symlink "gcc" link))
          (v-wrap-binary b "gcc")
          (v-wrap-binary b "g++")
          (v-wrap-binary b "cpp"))}
