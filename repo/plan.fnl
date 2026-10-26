;; repo, ported from its plan.sh.
{:name "repo"
 :origin "karate"
 :version "1.12.33"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache 2.0"]
 :description "Repo is a tool that [Google] built on top of Git. Repo helps\n[Google] manage the many Git repositories, does the uploads to [Google's]\nrevision control system, and automates parts of the Android development\nworkflow."
 :upstream_url "https://code.google.com/p/git-repo/"
 :source {:url "https://gerrit.googlesource.com/git-repo" :sha256 "d560e02daaf1bb800f806964962a95557ede6150d14e02e73ef1794c9aa98e60" :filename "repo"}
 :deps ["karate/cacerts" "karate/gnupg" "karate/python2"]
 :build_deps ["karate/git"]
 :bin_dirs ["bin"]
 :download (fn [b]
          (var v-git-ssl-cainfo (.. (b:path_for "karate/cacerts") "/ssl/certs/cacert.pem"))
          (b:env "GIT_SSL_CAINFO" v-git-ssl-cainfo)
          (b:run ["git" "clone" "https://gerrit.googlesource.com/git-repo"])
          (b:run ["git" "checkout" (.. "tags/v" b.version)] {:cwd "git-repo"})
          (b:copy b.name (.. b.cache "/" b.name))
          (b:chmod (.. b.cache "/" b.name) "755")
          (b:remove (b:join b.src "git-repo")))
 :unpack (fn [b]
          nil)
 :build (fn [b]
          nil)
 :install (fn [b]
          (b:mkdir (.. b.prefix "/bin"))
          (b:copy (.. b.cache "/" b.name) (.. b.prefix "/bin/" b.name))
          (b:chmod (.. b.prefix "/bin/" b.name) "0755")
          (var v-pythonpath (b:path_for "karate/python2"))
          (let [text (b:read (.. b.prefix "/bin/" b.name)) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line "/usr/bin/env python" (.. (pick-values 1 (: v-pythonpath :gsub "%%" "%%%%")) "/bin/python") 1))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (.. b.prefix "/bin/" b.name) (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" "")))))}
