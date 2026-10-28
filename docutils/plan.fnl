;; docutils, ported from its plan.sh.
{:name :docutils
 :origin :karate
 :version :0.14
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-3.0
           :BSD-2-Clause-FreeBSD
           :Python-2.0
           "Docutils Public Domain Dedication"]
 :description "Docutils is an open-source text processing system for processing plaintext documentation into useful formats, e.g.: HTML, LaTeX, man-pages, open-document, or XML."
 :upstream_url "http://docutils.sourceforge.net"
 :source {:url "https://downloads.sourceforge.net/project/docutils/docutils/0.14/docutils-0.14.tar.gz"
          :sha256 :51e64ef2ebfb29cae1faa133b3710143496eca21c530f3f71424d77687764274}
 :deps [:karate/bash :karate/python2]
 :build_deps [:karate/make :karate/gcc]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :build (fn [b]
          (b:run [:python :setup.py :install (.. :--prefix= b.prefix)]))
 :install (fn [b]
            (var v-bash-path "")
            (b:run [:python :install.py])
            (set v-bash-path (b:path_for :karate/bash))
            (each [_ v-file (ipairs (b:glob (.. b.prefix :/bin) :*.py))]
              (if (b:exists (.. v-file :.real))
                  (b:move v-file
                          (b:join (.. v-file :.real) (v-file:match "[^/]+$")))
                  (b:move v-file (.. v-file :.real)))
              (b:write v-file (.. "#!" v-bash-path
                                  "/bin/bash\nexport PYTHONPATH="
                                  (or (b:getenv :PYTHONPATH) "") ":" b.prefix
                                  "/lib/python2.7/site-packages\nexec " v-file ".real \"$@\"
"))
              (b:chmod v-file :a+x)))}
