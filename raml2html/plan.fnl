;; raml2html, ported from its plan.sh.
{:name "raml2html"
 :origin "karate"
 :version "6.3.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "RAML to HTML documentation generator."
 :upstream_url "https://github.com/raml2html/raml2html"
 :deps ["karate/node"]
 :bin_dirs ["bin"]
 :build (fn [b]
          (b:run ["env" (.. "PREFIX=" b.src) "npm" "i" "-g" (.. b.name "@" b.version)]))
 :install (fn [b]
          (var v-shebang "")
          (set v-shebang (.. "#!" (b:path_for "karate/node") "/bin/node"))
          (each [_ p (ipairs (b:glob (.. b.src "/lib/node_modules/" b.name) "*"))] (b:move p (b:join (.. b.prefix "/") (: p :match "[^/]+$"))))
          (each [v-bin (: (b:capture ["find" (.. b.prefix "/bin") "-type" "f"]) :gmatch "[^
          ]+")]
            (b:log (.. "Fixing Node shebang for " v-bin)) (let [text (b:read (if (= (: v-bin :sub 1 1) "/") v-bin (b:join b.src v-bin))) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line "^#!.*$" (pick-values 1 (: v-shebang :gsub "%%" "%%%%")) 1))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (if (= (: v-bin :sub 1 1) "/") v-bin (b:join b.src v-bin)) (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" ""))))))
 :strip (fn [b]
          nil)}
