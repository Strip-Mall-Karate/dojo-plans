;; github_changelog_generator, ported from its plan.sh.
(fn v-write-shim [b a1]
  (var v-bin "")
  (set v-bin (.. b.prefix :/bin/ a1))
  (b:log (.. "Adding wrapper " v-bin " to " v-bin :.real))
  (if (b:exists (.. v-bin :.real))
      (b:move v-bin (b:join (.. v-bin :.real) (: v-bin :match "[^/]+$")))
      (b:move v-bin (.. v-bin :.real)))
  (b:write v-bin (.. "#!" (b:path_for :busybox-static) "/bin/sh
set -e
export SSL_CERT_FILE=\""
                     (b:path_for :karate/cacerts) "/ssl/cert.pem\"
export GEM_HOME=\""
                     (or (b:getenv :GEM_HOME) "") "\"\nexport GEM_PATH=\""
                     (or (b:getenv :GEM_PATH) "") "\"\n\nexec " v-bin
                     ".real $@\n"))
  (b:chmod v-bin :755))

{:name :github_changelog_generator
 :origin :karate
 :version :1.14.3
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "Changelog generation has never been so easy. Fully automate changelog generation - this gem generate change log file based on tags, issues and merged pull requests from Github issue tracker."
 :upstream_url "https://github.com/skywinder/github-changelog-generator/blob/master/github_changelog_generator.gemspec"
 :deps [:karate/ruby :karate/git :karate/cacerts :karate/busybox-static]
 :bin_dirs [:bin]
 :prepare (fn [b]
            (b:env :GEM_HOME b.prefix)
            (b:log (.. "Setting GEM_HOME='" (or (b:getenv :GEM_HOME) "") "'"))
            (b:env :GEM_PATH b.prefix)
            (b:log (.. "Setting GEM_PATH='" (or (b:getenv :GEM_PATH) "") "'")))
 :build (fn [b]
          nil)
 :install (fn [b]
            (b:log "Installing from RubyGems")
            (b:run [:gem :install b.name :-v b.version :--no-document])
            (b:log (.. "Cleaning cached gems in " b.prefix :/cache))
            (b:remove (.. b.prefix :/cache))
            (v-write-shim b :git-generate-changelog)
            (v-write-shim b :github_changelog_generator))}
