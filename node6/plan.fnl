;; node6, ported from its plan.sh.
;; Built from the node plan, with its own changes.
{:name "node6"
 :origin "karate"
 :version "6.14.4"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "Node.js® is a JavaScript runtime built on Chrome's V8 JavaScript engine."
 :upstream_url "https://nodejs.org/"
 :source {:url "https://nodejs.org/dist/v6.14.4/node-v6.14.4.tar.gz" :sha256 "10aff5317908af04107e9ae26a07a84ee11a213657701df05c189afa4586cf37" :dirname "node-v6.14.4"}
 :deps ["karate/glibc" "karate/gcc-libs" "karate/python2" "karate/bash"]
 :build_deps ["karate/gcc" "karate/grep" "karate/make"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :interpreters ["bin/node"]
 :prepare (fn [b]
          (let [text (b:read (b:join b.src "configure")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line "/usr/bin/env python" (.. (pick-values 1 (: (b:path_for "python2") :gsub "%%" "%%%%")) "/bin/python2") 1))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join b.src "configure") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" "")))))
 :build (fn [b]
          (b:run ["./configure" "--prefix" b.prefix "--dest-cpu" "x64" "--dest-os" "linux"])
          (b:run ["make" (.. "-j" (tostring b.jobs))]))
 :install (fn [b]
          (b.default.install b)
          (each [v-target (: (b:capture ["grep" "-nrlI" "^\\#\\!/usr/bin/env" b.prefix]) :gmatch "[^
          ]+")]
            (let [text (b:read (if (= (: v-target :sub 1 1) "/") v-target (b:join b.src v-target))) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line "#!/usr/bin/env node" (.. "#!" (pick-values 1 (: b.prefix :gsub "%%" "%%%%")) "/bin/node") 1))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (if (= (: v-target :sub 1 1) "/") v-target (b:join b.src v-target)) (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" "")))) (let [text (b:read (if (= (: v-target :sub 1 1) "/") v-target (b:join b.src v-target))) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line "#!/usr/bin/env sh" (.. "#!" (pick-values 1 (: (b:path_for "bash") :gsub "%%" "%%%%")) "/bin/sh") 1))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (if (= (: v-target :sub 1 1) "/") v-target (b:join b.src v-target)) (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" "")))) (let [text (b:read (if (= (: v-target :sub 1 1) "/") v-target (b:join b.src v-target))) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line "#!/usr/bin/env bash" (.. "#!" (pick-values 1 (: (b:path_for "bash") :gsub "%%" "%%%%")) "/bin/bash") 1))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (if (= (: v-target :sub 1 1) "/") v-target (b:join b.src v-target)) (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" "")))) (let [text (b:read (if (= (: v-target :sub 1 1) "/") v-target (b:join b.src v-target))) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line "#!/usr/bin/env python" (.. "#!" (pick-values 1 (: (b:path_for "python2") :gsub "%%" "%%%%")) "/bin/python2") 1))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (if (= (: v-target :sub 1 1) "/") v-target (b:join b.src v-target)) (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" "")))))
          (let [text (b:read (.. b.prefix "/lib/node_modules/npm/bin/node-gyp-bin/node-gyp")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line "^[%s]*([%s])node([%s])" (.. "%1" (pick-values 1 (: b.prefix :gsub "%%" "%%%%")) "/bin/node%2") 1))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (.. b.prefix "/lib/node_modules/npm/bin/node-gyp-bin/node-gyp") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" "")))))}
