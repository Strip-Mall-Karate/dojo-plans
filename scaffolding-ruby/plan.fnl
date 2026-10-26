;; scaffolding-ruby, ported from its plan.sh.
(fn v-wrap-ruby-bin [b a1]
  (var v-bin "")
  (set v-bin a1)
  (b:log (.. "Adding wrapper " v-bin " to " v-bin ".real"))
  (if (b:exists (.. v-bin ".real"))
    (b:move v-bin (b:join (.. v-bin ".real") (: v-bin :match "[^/]+$")))
    (b:move v-bin (.. v-bin ".real")))
  (b:write v-bin (.. "#!" (b:path_for "busybox-static") "/bin/sh\nset -e\nif test -n \"" (or (b:getenv "DEBUG") "") "\"; then set -x; fi\n\nexport GEM_HOME=\"" (or (b:getenv "GEM_HOME") "") "\"\nexport GEM_PATH=\"" (or (b:getenv "GEM_PATH") "") "\"\nunset RUBYOPT GEMRC\n\nexec " (b:path_for "ruby") "/bin/ruby " v-bin ".real $@\n"))
  (b:chmod v-bin "755"))
{:name "scaffolding-ruby"
 :origin "karate"
 :version "0.8.10"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "Dojo Plan Scaffolding for Ruby Applications"
 :upstream_url "https://github.com/Strip-Mall-Karate/dojo-plans/tree/master/scaffolding-ruby"
 :deps ["karate/bundler" "karate/ruby" "karate/tar" "karate/busybox-static" "karate/rq" "karate/gcc" "karate/make" "karate/pkg-config"]
 :build_deps ["karate/coreutils" "karate/sed"]
 :bin_dirs ["bin"]
 :prepare (fn [b]
          (var v-gem-home (b:path_for "bundler"))
          (b:log (.. "Setting GEM_HOME=" v-gem-home))
          (var v-gem-path v-gem-home)
          (b:log (.. "Setting GEM_PATH=" v-gem-path))
          (b:env "GEM_HOME" v-gem-home)
          (b:env "GEM_PATH" v-gem-path))
 :build (fn [b]
          nil)
 :install (fn [b]
          (each [v-f (: (b:capture ["find" "lib" "-type" "f"]) :gmatch "[^
          ]+")]
            (b:copy (if (= (: v-f :sub 1 1) "/") v-f (b:join b.src v-f)) (.. b.prefix "/" v-f)) (b:chmod (.. b.prefix "/" v-f) "0644"))
          (each [v-f (: (b:capture ["find" "bin" "libexec" "-type" "f"]) :gmatch "[^
          ]+")]
            (b:copy (if (= (: v-f :sub 1 1) "/") v-f (b:join b.src v-f)) (.. b.prefix "/" v-f)) (b:chmod (.. b.prefix "/" v-f) "0755"))
          (let [text (b:read (.. b.prefix "/lib/ruby_scaffolding/cli.rb")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line "@author@" (pick-values 1 (: "Strip Mall Karate Company" :gsub "%%" "%%%%"))))))
              (when (not deleted) (set line (pick-values 1 (string.gsub line "@version@" (.. (pick-values 1 (: b.version :gsub "%%" "%%%%")) "/" (pick-values 1 (: b.release :gsub "%%" "%%%%")))))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (.. b.prefix "/lib/ruby_scaffolding/cli.rb") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" ""))))
          (v-wrap-ruby-bin b (.. b.prefix "/bin/gemfile-parser")))}
