;; linux, ported from its plan.sh.
(var v--pwd-binlink "")
(fn v-set-ld-library-path [b]
  (var v-data "")
  (var v-dep-path "")
  (var v-ld-library-path-part "")
  (var v-trimmed "")
  (set v-ld-library-path-part [])
  ;; Each build dependency's LD_RUN_PATH, trimmed.
  (each [_ dep (ipairs ["karate/bc" "karate/bison" "karate/diffutils" "karate/elfutils" "karate/findutils" "karate/gcc"
                        "karate/inetutils" "karate/make" "karate/perl" "karate/openssl"])]
    (let [file (.. (b:path_for dep) "/LD_RUN_PATH")]
      (when (b:exists file)
        (table.insert v-ld-library-path-part ((b:read file):match "^%s*(.-)%s*$")))))
  (b:env "LD_LIBRARY_PATH" (table.concat v-ld-library-path-part ":")))
{:name "linux"
 :origin "karate"
 :version "4.16.7"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["gplv2"]
 :description "The Linux kernel"
 :upstream_url "https://www.kernel.org/"
 :source {:url "https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.16.7.tar.xz" :sha256 "d87abef6c5666329194a0005fa8331c0cc03b65383f195442dee8f5558af0139"}
 :deps ["karate/glibc"]
 :build_deps ["karate/bc" "karate/bison" "karate/diffutils" "karate/elfutils" "karate/findutils" "karate/gcc" "karate/inetutils" "karate/make" "karate/perl" "karate/openssl"]
 :download (fn [b]
          ;; From do_begin.
          ;; The plan linked coreutils' pwd to /bin/pwd for the build. Linux 4.16.7 names
          ;; /bin/pwd only in its documentation, so nothing takes its place.
          (b.default.download b))
 :prepare (fn [b]
          (b:run ["make" "mrproper"])
          (if (b:exists (.. b.cache "/" (.. b.name "-" b.version) "/.config"))
            (b:copy (.. b.plan_dir "/config/config.x86_64") (b:join (.. b.cache "/" (.. b.name "-" b.version) "/.config") (: (.. b.plan_dir "/config/config.x86_64") :match "[^/]+$")))
            (b:copy (.. b.plan_dir "/config/config.x86_64") (.. b.cache "/" (.. b.name "-" b.version) "/.config"))))
 :build (fn [b]
          (v-set-ld-library-path b)
          (let [text (b:read (b:join b.src "Makefile")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (when (= n 969) (set line (pick-values 1 (string.gsub line "%-xc" (.. (pick-values 1 (: (or (b:getenv "LDFLAGS") "") :gsub "%%" "%%%%")) " -xc") 1)))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join b.src "Makefile") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" ""))))
          (let [text (b:read (b:join b.src "Makefile")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (when (= n 367) (set line (pick-values 1 (string.gsub line "$" (.. " " (pick-values 1 (: (or (b:getenv "LDFLAGS") "") :gsub "%%" "%%%%"))) 1)))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join b.src "Makefile") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" ""))))
          (let [text (b:read (b:join b.src "scripts/Makefile.host")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (when (= n 87) (set line (pick-values 1 (string.gsub line "$%(hostc_flags%)" "$(hostc_flags) $(HOSTLDFLAGS)" 1)))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join b.src "scripts/Makefile.host") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" ""))))
          (let [text (b:read (b:join b.src "tools/objtool/Makefile")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (when (= n 50) (set line (pick-values 1 (string.gsub line "$%(LDFLAGS%)" "$(LDFLAGS) $(HOSTLDFLAGS)" 1)))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join b.src "tools/objtool/Makefile") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" ""))))
          (b:run ["make" "-j" (tostring b.jobs) "bzImage" "modules"] {:env {"HOST_EXTRACFLAGS" (or (b:getenv "CFLAGS") "")}})
          (b:unsetenv "LD_LIBRARY_PATH"))
 :install (fn [b]
          (b:run ["make" (.. "INSTALL_MOD_PATH=" b.prefix) "modules_install"])
          (b:mkdir (.. b.prefix "/boot"))
          (b:copy (b:join b.src "arch/x86/boot/bzImage") (b:join (.. b.prefix "/boot/") (: (b:join b.src "arch/x86/boot/bzImage") :match "[^/]+$")))
          (b:run ["find" b.prefix "-type" "l" "-delete"]))
 :strip (fn [b]
          (b.default.strip b)
          ;; From do_end.
          )}
