;; tree, ported from its plan.sh.
{:name "tree"
 :origin "karate"
 :version "1.8.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["gplv2+"]
 :description "A utility to display a tree view of directories."
 :upstream_url "http://mama.indstate.edu/users/ice/tree/"
 :source {:url "http://mama.indstate.edu/users/ice/tree/src/tree-1.8.0.tgz" :sha256 "715d5d4b434321ce74706d0dd067505bb60c5ea83b5f0b3655dae40aa6f9b7c2"}
 :deps ["karate/glibc"]
 :build_deps ["karate/make" "karate/gcc"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["make"]))
 :install (fn [b]
          (let [text (b:read (b:join b.src "Makefile")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line "prefix = /usr" (.. "prefix = " (pick-values 1 (: b.prefix :gsub "%%" "%%%%"))) 1))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join b.src "Makefile") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" ""))))
          (b:run ["make" "install"]))}
