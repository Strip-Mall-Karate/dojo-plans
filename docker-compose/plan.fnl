;; docker-compose, ported from its plan.sh.
{:name :docker-compose
 :origin :karate
 :version :1.23.2
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0]
 :description "Define and run multi-container applications with Docker"
 :upstream_url "https://docs.docker.com/compose/install/"
 :deps [:karate/python]
 :bin_dirs [:bin]
 :prepare (fn [b]
            (b:run [:python :-m :venv b.prefix])
            (b:env :VIRTUAL_ENV
                   (: (.. b.prefix :/bin/activate) :gsub :/bin/activate$ ""))
            (b:env :PATH
                   (.. (: (.. b.prefix :/bin/activate) :gsub :/bin/activate$ "")
                       "/bin:" (or (b:getenv :PATH) ""))))
 :build (fn [b]
          nil)
 :install (fn [b]
            (b:run [:pip :install (.. :docker-compose== b.version)])
            (b:write (.. b.prefix :/requirements.txt)
                     (.. (b:capture [:pip :freeze]) "\n")))
 :strip (fn [b]
          nil)}
