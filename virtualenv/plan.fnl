;; virtualenv, ported from its plan.sh.
{:name :virtualenv
 :origin :karate
 :version :15.0.3
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "virtualenv is a tool to create isolated Python environments. This version is for python2. For python3 use the built-in 'pyvenv'"
 :upstream_url "https://virtualenv.pypa.io/"
 :source {:url "https://pypi.io/packages/source/v/virtualenv/virtualenv-15.0.3.tar.gz"
          :sha256 :6d9c760d3fc5fa0894b0f99b9de82a4647e1164f0b700a7f99055034bf548b1d}
 :deps [:karate/python2]
 :bin_dirs [:bin]
 :build (fn [_b]
          nil)
 :install (fn [b]
            (b:env :PYTHONPATH (.. b.prefix :/lib/python2.7/site-packages/))
            (b:mkdir (or (b:getenv :PYTHONPATH) ""))
            (b:run [:python :setup.py :install (.. :--prefix= b.prefix)])
            (let [text (b:read (.. b.prefix :/bin/virtualenv))
                  ends (= (text:sub -1) "\n")
                  lines []
                  out []]
              (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")]
                (table.insert lines l))
              (each [n l (ipairs lines)]
                (local line l)
                (local deleted false)
                (local after [])
                (when (not deleted)
                  (when (= n 2)
                    (table.insert out
                                  (.. "import sys; sys.path.append(\""
                                      (or (b:getenv :PYTHONPATH) "") "\")"))))
                (when (not deleted) (table.insert out line))
                (each [_ x (ipairs after)] (table.insert out x)))
              (b:write (.. b.prefix :/bin/virtualenv)
                       (.. (table.concat out "\n")
                           (if (and ends (> (length out) 0))
                               "\n"
                               "")))))}
