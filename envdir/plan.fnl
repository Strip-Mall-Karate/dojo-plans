;; envdir, ported from its plan.sh.
{:name "envdir"
 :origin "karate"
 :version "1.0.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "Envdir runs another program with a modified environment according to files in a specified directory."
 :upstream_url "https://github.com/jezdez/envdir"
 :deps ["karate/python"]
 :bin_dirs ["bin"]
 :download (fn [b]
          nil)
 :verify (fn [b]
          nil)
 :unpack (fn [b]
          nil)
 :prepare (fn [b]
          (b:run ["pyvenv" b.prefix])
          (b:env "VIRTUAL_ENV" (: (.. b.prefix "/bin/activate") :gsub "/bin/activate$" ""))
          (b:env "PATH" (.. (: (.. b.prefix "/bin/activate") :gsub "/bin/activate$" "") "/bin:" (or (b:getenv "PATH") ""))))
 :build (fn [b]
          nil)
 :install (fn [b]
          (b:run ["pip" "install" (.. b.name "==" b.version)])
          (b:write (.. b.prefix "/requirements.txt") (.. (b:capture ["pip" "freeze"]) "\n")))}
