;; bundler, ported from its plan.sh.
(fn v-wrap-ruby-bin [b a1]
  (var v-bin "")
  (set v-bin a1)
  (b:log (.. "Adding wrapper " v-bin " to " v-bin :.real))
  (if (b:exists (.. v-bin :.real))
      (b:move v-bin (b:join (.. v-bin :.real) (v-bin:match "[^/]+$")))
      (b:move v-bin (.. v-bin :.real)))
  (b:write v-bin (.. "#!" (b:path_for :busybox-static) "/bin/sh
set -e
if test -n \""
                     (or (b:getenv :DEBUG) "") "\"; then set -x; fi

export GEM_HOME=\""
                     (or (b:getenv :GEM_HOME) "") "\"\nexport GEM_PATH=\""
                     (or (b:getenv :GEM_PATH) "")
                     "\"\nunset RUBYOPT GEMRC\n\nexec " (b:path_for :ruby)
                     "/bin/ruby " v-bin ".real $@\n"))
  (b:chmod v-bin :755))

{:name :bundler
 :origin :karate
 :version :1.17.3
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:bundler]
 :description "The Ruby language dependency manager"
 :upstream_url "https://bundler.io/"
 :deps [:karate/ruby :karate/busybox-static]
 :bin_dirs [:bin]
 :prepare (fn [b]
            (b:env :GEM_HOME b.prefix)
            (b:log (.. "Setting GEM_HOME='" (or (b:getenv :GEM_HOME) "") "'"))
            (b:env :GEM_PATH (or (b:getenv :GEM_HOME) ""))
            (b:log (.. "Setting GEM_PATH='" (or (b:getenv :GEM_PATH) "") "'")))
 :build (fn [_b]
          nil)
 :install (fn [b]
            (b:log "Installing from RubyGems")
            (b:run [:gem :install b.name :-v b.version :--no-document])
            (v-wrap-ruby-bin b (.. b.prefix :/bin/bundle))
            (v-wrap-ruby-bin b (.. b.prefix :/bin/bundler)))}
