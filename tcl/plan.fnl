;; tcl, ported from its plan.sh.
;; tcl 8.6.18, the latest 8.6 release on 2026-10-26: Tcl 9 breaks expect 5.45.4 and the plan's 8.6 layout.
{:name "tcl"
 :origin "karate"
 :version "8.6.18"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["custom"]
 :description "Tool Command Language -- A dynamic programming language."
 :upstream_url "http://tcl.sourceforge.net/"
 :source {:url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.18/tcl8.6.18-src.tar.gz" :sha256 "14f9af32b1767ff718477a8f974ad03c34341097e6b43f4ce54644ee974e268e" :dirname "tcl8.6.18"}
 :deps ["karate/glibc" "karate/gcc-libs" "karate/zlib"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/sed"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :build (fn [b]
          (var v-itclver "")
          (var v-srcdir "")
          (var v-tdbcver "")
          (b:env "LDFLAGS" (.. "-lgcc_s " (or (b:getenv "LDFLAGS") "")))
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--enable-threads" "--enable-64bit"] {:cwd "unix"})
          (b:run ["make"] {:cwd "unix"})
          (set v-srcdir (: (b:join b.src "unix") :match "^(.*)/[^/]+$"))
          (set v-tdbcver "tdbc1.1.13")
          (set v-itclver "itcl4.3.7")
          (let [text (b:read (b:join (b:join b.src "unix") "tclConfig.sh")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line (.. (pick-values 1 (: v-srcdir :gsub "[%^%$%(%)%%%.%[%]%*%+%-%?]" "%%%0")) "/unix") (.. (pick-values 1 (: b.prefix :gsub "%%" "%%%%")) "/lib") 1))))
              (when (not deleted) (set line (pick-values 1 (string.gsub line (pick-values 1 (: v-srcdir :gsub "[%^%$%(%)%%%.%[%]%*%+%-%?]" "%%%0")) (.. (pick-values 1 (: b.prefix :gsub "%%" "%%%%")) "/include") 1))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join (b:join b.src "unix") "tclConfig.sh") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" ""))))
          (let [text (b:read (b:join (b:join b.src "unix") (.. "pkgs/" v-tdbcver "/tdbcConfig.sh"))) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line (.. (pick-values 1 (: v-srcdir :gsub "[%^%$%(%)%%%.%[%]%*%+%-%?]" "%%%0")) "/unix/pkgs/" (pick-values 1 (: v-tdbcver :gsub "[%^%$%(%)%%%.%[%]%*%+%-%?]" "%%%0"))) (.. (pick-values 1 (: b.prefix :gsub "%%" "%%%%")) "/lib/" (pick-values 1 (: v-tdbcver :gsub "%%" "%%%%"))) 1))))
              (when (not deleted) (set line (pick-values 1 (string.gsub line (.. (pick-values 1 (: v-srcdir :gsub "[%^%$%(%)%%%.%[%]%*%+%-%?]" "%%%0")) "/pkgs/" (pick-values 1 (: v-tdbcver :gsub "[%^%$%(%)%%%.%[%]%*%+%-%?]" "%%%0")) "/generic") (.. (pick-values 1 (: b.prefix :gsub "%%" "%%%%")) "/include") 1))))
              (when (not deleted) (set line (pick-values 1 (string.gsub line (.. (pick-values 1 (: v-srcdir :gsub "[%^%$%(%)%%%.%[%]%*%+%-%?]" "%%%0")) "/pkgs/" (pick-values 1 (: v-tdbcver :gsub "[%^%$%(%)%%%.%[%]%*%+%-%?]" "%%%0")) "/library") (.. (pick-values 1 (: b.prefix :gsub "%%" "%%%%")) "/lib/tcl" (pick-values 1 (: "8.6" :gsub "%%" "%%%%"))) 1))))
              (when (not deleted) (set line (pick-values 1 (string.gsub line (.. (pick-values 1 (: v-srcdir :gsub "[%^%$%(%)%%%.%[%]%*%+%-%?]" "%%%0")) "/pkgs/" (pick-values 1 (: v-tdbcver :gsub "[%^%$%(%)%%%.%[%]%*%+%-%?]" "%%%0"))) (.. (pick-values 1 (: b.prefix :gsub "%%" "%%%%")) "/include") 1))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join (b:join b.src "unix") (.. "pkgs/" v-tdbcver "/tdbcConfig.sh")) (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" ""))))
          (let [text (b:read (b:join (b:join b.src "unix") (.. "pkgs/" v-itclver "/itclConfig.sh"))) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line (.. (pick-values 1 (: v-srcdir :gsub "[%^%$%(%)%%%.%[%]%*%+%-%?]" "%%%0")) "/unix/pkgs/" (pick-values 1 (: v-itclver :gsub "[%^%$%(%)%%%.%[%]%*%+%-%?]" "%%%0"))) (.. (pick-values 1 (: b.prefix :gsub "%%" "%%%%")) "/lib/" (pick-values 1 (: v-itclver :gsub "%%" "%%%%"))) 1))))
              (when (not deleted) (set line (pick-values 1 (string.gsub line (.. (pick-values 1 (: v-srcdir :gsub "[%^%$%(%)%%%.%[%]%*%+%-%?]" "%%%0")) "/pkgs/" (pick-values 1 (: v-itclver :gsub "[%^%$%(%)%%%.%[%]%*%+%-%?]" "%%%0")) "/generic") (.. (pick-values 1 (: b.prefix :gsub "%%" "%%%%")) "/include") 1))))
              (when (not deleted) (set line (pick-values 1 (string.gsub line (.. (pick-values 1 (: v-srcdir :gsub "[%^%$%(%)%%%.%[%]%*%+%-%?]" "%%%0")) "/pkgs/" (pick-values 1 (: v-itclver :gsub "[%^%$%(%)%%%.%[%]%*%+%-%?]" "%%%0"))) (.. (pick-values 1 (: b.prefix :gsub "%%" "%%%%")) "/include") 1))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join (b:join b.src "unix") (.. "pkgs/" v-itclver "/itclConfig.sh")) (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" "")))))
 :install (fn [b]
          (b:run ["make" "install"] {:cwd "unix"})
          (b:run ["make" "install-private-headers"] {:cwd "unix"})
          (let [link (if (b:exists (b:join (.. b.prefix "/bin/tclsh") ".")) (b:join (.. b.prefix "/bin/tclsh") "tclsh8.6") (.. b.prefix "/bin/tclsh"))]
            (b:remove link) (b:symlink "tclsh8.6" link))
          (b:chmod (.. b.prefix "/lib/libtcl8.6.so") "755")
          (let [link (if (b:exists (b:join (.. b.prefix "/lib/libtcl.so") ".")) (b:join (.. b.prefix "/lib/libtcl.so") "libtcl8.6.so") (.. b.prefix "/lib/libtcl.so"))]
            (b:remove link) (b:symlink "libtcl8.6.so" link))
          (b:copy (b:join (b:join b.src "unix") "../license.terms") (.. b.prefix "/share/licenses/LICENSE"))
          (b:chmod (.. b.prefix "/share/licenses/LICENSE") "644"))}
