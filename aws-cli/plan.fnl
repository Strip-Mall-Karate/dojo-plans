;; aws-cli, ported from its plan.sh.
;; The source project's plan asked PyPI for awscli's newest version at build time.
;; This is the version current on 10 April 2019, pinned.
{:name :aws-cli
 :origin :karate
 :maintainer "Strip Mall Karate Company"
 :targets [:x86_64-linux]
 :license [:Apache-2.0]
 :description "The AWS Command Line Interface (CLI) is a unified tool to manage your AWS services. With just one tool to download and configure, you can control multiple AWS services from the command line and automate them through scripts."
 :upstream_url "https://aws.amazon.com/cli/"
 :version :1.16.140
 :deps [:karate/groff :karate/python]
 :build_deps [:karate/gawk :karate/sed]
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
            (b:run [:pip :install (.. :awscli== b.version)])
            (b:write (.. b.prefix :/requirements.txt)
                     (.. (b:capture [:pip :freeze]) "\n")))
 :strip (fn [b]
          nil)}
