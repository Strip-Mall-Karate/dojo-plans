;; curator4, ported from its plan.sh.
{:name "curator4"
 :origin "karate"
 :version "4.2.6"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "Elasticsearch Curator helps you curate, or manage your indices."
 :upstream_url "https://github.com/elastic/curator"
 :deps ["karate/python2"]
 :build_deps ["karate/virtualenv"]
 :bin_dirs ["bin"]
 :download (fn [b]
          nil)
 :verify (fn [b]
          nil)
 :unpack (fn [b]
          nil)
 :prepare (fn [b]
          (b:run ["localedef" "-i" "en_US" "-f" "UTF-8" "en_US.UTF-8"])
          (b:env "LC_ALL" "en_US.UTF-8")
          (b:env "LANG" "en_US.UTF-8")
          (b:run ["virtualenv" b.prefix])
          (b:env "VIRTUAL_ENV" (: (.. b.prefix "/bin/activate") :gsub "/bin/activate$" ""))
          (b:env "PATH" (.. (: (.. b.prefix "/bin/activate") :gsub "/bin/activate$" "") "/bin:" (or (b:getenv "PATH") ""))))
 :build (fn [b]
          nil)
 :install (fn [b]
          (b:run ["pip" "install" (.. "elasticsearch-curator==" b.version)])
          (b:write (.. b.prefix "/requirements.txt") (.. (b:capture ["pip" "freeze"]) "\n")))}
