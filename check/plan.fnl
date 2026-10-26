;; check, ported from its plan.sh.
{:name "check"
 :origin "karate"
 :version "0.12.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["LGPL-2.1-or-later"]
 :description "Check is a unit testing framework for C. It features a simple interface for defining unit tests, putting little in the way of the developer. Tests are run in a separate address space, so both assertion failures and code errors that cause segmentation faults or other signals can be caught."
 :upstream_url "https://libcheck.github.io/check"
 :source {:url "https://github.com/libcheck/check/releases/download/0.12.0/check-0.12.0.tar.gz" :sha256 "464201098bee00e90f5c4bdfa94a5d3ead8d641f9025b560a27755a83b824234"}
 :deps ["karate/gawk" "karate/glibc"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/file" "karate/gcc" "karate/make" "karate/sed"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :prepare (fn [b]
          (let [text (b:read (b:join b.src "configure")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line "/usr/bin/file" "file"))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join b.src "configure") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" "")))))
 :check (fn [b]
          (var v--interpreter "")
          (set v--interpreter (.. (b:path_for "karate/coreutils") "/bin/env"))
          (let [text (b:read (b:join b.src "checkmk/test/check_checkmk")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line "#!/usr/bin/env" (.. "#!" (pick-values 1 (: v--interpreter :gsub "%%" "%%%%"))) 1))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join b.src "checkmk/test/check_checkmk") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" ""))))
          (each [_ v-f (ipairs (b:glob (b:join b.src "tests") "test_*"))]
            (let [text (b:read v-f) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line "#!/usr/bin/env" (.. "#!" (pick-values 1 (: v--interpreter :gsub "%%" "%%%%"))) 1))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write v-f (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" "")))))
          (b:run ["make" "check"]))
 :install (fn [b]
          (b.default.install b)
          (b:remove (.. b.prefix "/share/info/dir"))
          (b:remove (.. b.prefix "/share/doc/check/*ChangeLog*")))}
