;; binutils, ported from its plan.sh.
;; binutils 2.47, the latest release on 2026-10-26.
(var v-bash "")
(var v-dynamic-linker "")
(fn v--verify-tty [b]
  (var v-actual "")
  (var v-cmd "")
  (var v-expected "")
  (set v-expected "spawn ls")
  (set v-cmd "expect -c 'spawn ls'")
  ;; The output of expect, each line's carriage return removed.
  (let [actual (pick-values 1 (: (: (b:capture ["expect" "-c" "spawn ls"]) :gsub "\r\n" "\n") :gsub "\r$" ""))]
    (when (not= v-expected actual)
      (error (.. "Expected out from '" v-cmd "' was: '" v-expected "', actual: '" actual "'"))))
  )
(fn v--wrap-binary [b a1]
  (var v-bin "")
  (set v-bin (.. b.prefix "/bin/" a1))
  (b:log (.. "Adding wrapper " v-bin " to " v-bin ".real"))
  (if (b:exists (.. v-bin ".real"))
    (b:move v-bin (b:join (.. v-bin ".real") (: v-bin :match "[^/]+$")))
    (b:move v-bin (.. v-bin ".real")))
  (b:write v-bin (let [text (b:read (.. b.plan_dir "/ld-wrapper.sh")) ends (= (text:sub -1) "\n") lines [] out []]
    (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
    (each [n l (ipairs lines)]
      (var line l) (var deleted false) (local after [])
      (when (not deleted) (set line (pick-values 1 (string.gsub line "@shell@" (pick-values 1 (: v-bash :gsub "%%" "%%%%"))))))
      (when (not deleted) (set line (pick-values 1 (string.gsub line "@dynamic_linker@" (pick-values 1 (: v-dynamic-linker :gsub "%%" "%%%%"))))))
      (when (not deleted) (set line (pick-values 1 (string.gsub line "@program@" (.. (pick-values 1 (: v-bin :gsub "%%" "%%%%")) ".real")))))
      (when (not deleted) (table.insert out line))
      (each [_ x (ipairs after)] (table.insert out x)))
    (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" ""))))
  (b:chmod v-bin "755"))
{:name "binutils"
 :origin "karate"
 :version "2.47"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["gpl"]
 :description "The GNU Binary Utilities, or binutils, are a set of programming tools for creating and managing binary programs, object files, libraries, profile data, and assembly source code."
 :upstream_url "https://www.gnu.org/software/binutils/"
 :source {:url "https://ftp.gnu.org/gnu/binutils/binutils-2.47.tar.xz" :sha256 "154ab23b60070e8f27013c22977f1129425d67d1e8acd6e13010e617811e4cff"}
 :deps ["karate/glibc" "karate/zlib"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/texinfo" "karate/expect" "karate/dejagnu"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :prepare (fn [b]
          (v--verify-tty b)
          (set v-dynamic-linker (.. (b:path_for "glibc") "/lib/ld-linux-x86-64.so.2"))
          (b:env "LDFLAGS" (.. "-L" (b:path_for "zlib") "/lib"))
          (b:env "LDFLAGS" (.. (or (b:getenv "LDFLAGS") "") " -Wl,-rpath=" (or (b:getenv "LD_RUN_PATH") "") ",--enable-new-dtags"))
          (b:env "LDFLAGS" (.. (or (b:getenv "LDFLAGS") "") " -Wl,--dynamic-linker=" v-dynamic-linker))
          (b:log (.. "Updating LDFLAGS=" (or (b:getenv "LDFLAGS") "")))
          (b:env "CFLAGS" (.. "-I" (b:path_for "zlib") "/include"))
          (b:log (.. "Updating CFLAGS=" (or (b:getenv "CFLAGS") "")))
          (b:env "CXXFLAGS" (or (b:getenv "CFLAGS") ""))
          (b:log (.. "Updating CXXFLAGS=" (or (b:getenv "CXXFLAGS") "")))
          (b:env "CPPFLAGS" (or (b:getenv "CFLAGS") ""))
          (b:log (.. "Updating CPPFLAGS=" (or (b:getenv "CPPFLAGS") "")))
          (set v-bash "/bin/bash")
          (b:run ["patch" "-p1" "-i" (.. b.plan_dir "/new-dtags.patch")])
          (b:run ["patch" "-p1" "-i" (.. b.plan_dir "/dt-needed-true.patch")])
          (b:run ["patch" "-p1" "-i" (.. b.plan_dir "/more-deterministic-output.patch")])
          (b:run ["patch" "-p1"] {:stdin (let [text (b:read (.. b.plan_dir "/disable_failing_tests.patch")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line "@zlib_libs@" (.. (pick-values 1 (: (b:path_for "zlib") :gsub "%%" "%%%%")) "/lib")))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" "")))})
          (b:run ["patch" "-p1" "-i" (.. b.plan_dir "/0001-PR23428-x86-Add-a-GNU_PROPERTY_X86_ISA_1_USED-note-if-needed.patch")])
          (b:run ["patch" "-p1" "-i" (.. b.plan_dir "/0005-PR23486-x86-Properly-merge-GNU_PROPERTY_X86_ISA_1_USED.patch")])
          (b:run ["patch" "-p1" "-i" (.. b.plan_dir "/0006-PR23428-x86-Properly-add-X86_ISA_1_NEEDED-property.patch")])
          (b:write (b:join b.src "ld/configure.tgt") (.. (if (b:exists (b:join b.src "ld/configure.tgt")) (b:read (b:join b.src "ld/configure.tgt")) "") "NATIVE_LIB_DIRS=\n"))
          (each [_ v-f (ipairs ["binutils/Makefile.in" "gas/Makefile.in" "ld/Makefile.in"])]
            (let [text (b:read (if (= (: v-f :sub 1 1) "/") v-f (b:join b.src v-f))) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line "ln " "ln -s " 1))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (if (= (: v-f :sub 1 1) "/") v-f (b:join b.src v-f)) (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" ""))))))
 :build (fn [b]
          (b:remove (b:join b.src (.. "../" b.name "-build")))
          (b:mkdir (b:join b.src (.. "../" b.name "-build")))
          (b:run [(.. "../" (.. b.name "-" b.version) "/configure") (.. "--prefix=" b.prefix) "--enable-shared" "--enable-gold" "--enable-ld=default" "--enable-plugins" "--enable-deterministic-archives" "--enable-threads" "--disable-werror" "--with-system-zlib"] {:cwd (.. "../" b.name "-build")})
          (b:run ["make" "configure-host"] {:cwd (.. "../" b.name "-build")})
          (b:run ["make" (.. "-j" (tostring b.jobs)) (.. "tooldir=" b.prefix)] {:cwd (.. "../" b.name "-build")}))
 :check (fn [b]
          (var v-original-ld-run-path "")
          (set v-original-ld-run-path (or (b:getenv "LD_RUN_PATH") ""))
          (if (= (or (b:getenv "STUDIO_TYPE") "") "stage1")
            (do (b:env "LD_LIBRARY_PATH" (.. (or (b:getenv "LD_RUN_PATH") "") ":/tools/lib")))
            (do (b:env "LD_LIBRARY_PATH" (.. (or (b:getenv "LD_RUN_PATH") "") ":" (b:path_for "gcc") "/lib"))))
          (b:unsetenv "LD_RUN_PATH")
          (b:run ["make" "check" (.. "LDFLAGS=" (or (b:getenv "LDFLAGS") ""))] {:cwd (.. "../" b.name "-build")})
          (b:unsetenv "LD_LIBRARY_PATH")
          (b:env "LD_RUN_PATH" v-original-ld-run-path))
 :install (fn [b]
          (b:run ["make" (.. "prefix=" b.prefix) (.. "tooldir=" b.prefix) "install"] {:cwd (.. "../" b.name "-build")})
          (each [_ p (ipairs (b:glob (.. b.prefix "/share/man/man1") "dlltool*"))] (b:remove p))
          (each [_ p (ipairs (b:glob (.. b.prefix "/share/man/man1") "nlmconv*"))] (b:remove p))
          (each [_ p (ipairs (b:glob (.. b.prefix "/share/man/man1") "windres*"))] (b:remove p))
          (each [_ p (ipairs (b:glob (.. b.prefix "/share/man/man1") "windmc*"))] (b:remove p))
          (b:remove (.. b.prefix "/lib/libbfd.so"))
          (b:remove (.. b.prefix "/lib/libopcodes.so"))
          (v--wrap-binary b "ld.bfd"))}
