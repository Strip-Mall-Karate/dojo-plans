;; mercurial, ported from its plan.sh.
(fn v-install-cacerts [b]
  (b:log "Writing hgrc with cacerts config")
  (b:mkdir (.. b.prefix "/etc/mercurial"))
  (b:write (.. b.prefix "/etc/mercurial/hgrc") (.. "[web]\ncacerts = " (b:path_for "cacerts") "/ssl/cert.pem\n")))
(fn v-fix-test-interpreters [b]
  (var v-files-to-fix-env "")
  (var v-interpreter-new "")
  (var v-interpreter-old "")
  (set v-files-to-fix-env ["contrib/check-commit" "contrib/check-code.py" "tests/bundles/rebase.sh" "tests/check-perf-code.py" "tests/dumbhttp.py" "tests/dummysmtpd.py" "tests/dummyssh" "tests/f" "tests/filterpyflakes.py" "tests/get-with-headers.py" "tests/hghave" "tests/killdaemons.py" "tests/md5sum.py" "tests/printenv.py" "tests/readlink.py" "tests/revlog-formatv0.py" "tests/run-tests.py" "tests/seq.py" "tests/svn-safe-append.py" "tests/test-bisect.t" "tests/test-extdiff.t" "tests/test-extension.t" "tests/test-filelog.py" "tests/test-highlight.t" "tests/test-largefiles-cache.t" "tests/test-merge-symlinks.t" "tests/test-newcgi.t" "tests/test-newercgi.t" "tests/test-oldcgi.t" "tests/test-run-tests.t" "tests/test-status-inprocess.py" "tests/tinyproxy.py"])
  (set v-interpreter-old "/usr/bin/env")
  (set v-interpreter-new (.. (b:path_for "coreutils") "/bin/env"))
  (each [_ v-f (ipairs v-files-to-fix-env)]
    (b:log (.. "Fixing interpreter on " v-f)) (let [text (b:read v-f) ends (= (text:sub -1) "\n") lines [] out []]
    (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
    (each [n l (ipairs lines)]
      (var line l) (var deleted false) (local after [])
      (when (not deleted) (set line (pick-values 1 (string.gsub line (.. "#!" (pick-values 1 (: v-interpreter-old :gsub "[%^%$%(%)%%%.%[%]%*%+%-%?]" "%%%0"))) (.. "#!" (pick-values 1 (: v-interpreter-new :gsub "%%" "%%%%"))) 1))))
      (when (not deleted) (table.insert out line))
      (each [_ x (ipairs after)] (table.insert out x)))
    (b:write v-f (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" ""))))))
{:name "mercurial"
 :origin "karate"
 :version "3.9.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["GPL-2.0"]
 :description "A free, distributed source control management tool."
 :upstream_url "https://www.mercurial-scm.org/"
 :source {:url "https://www.mercurial-scm.org/release/mercurial-3.9.1.tar.gz" :sha256 "625e4fc7e85ec2278c2828bdc547fce74091b3bbe4d9eeeba2d61af51195df74"}
 :deps ["karate/glibc" "karate/python2" "karate/cacerts"]
 :build_deps ["karate/gcc" "karate/make" "karate/python2" "karate/coreutils" "karate/diffutils" "karate/which"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :build (fn [b]
          (b:run ["make" "build" (.. "PREFIX=" b.prefix)]))
 :check (fn [b]
          (v-fix-test-interpreters b)
          (b:run ["make" "tests" (.. "PREFIX=" b.prefix)]))
 :install (fn [b]
          (b:run ["make" "install-bin" (.. "PREFIX=" b.prefix)])
          (v-install-cacerts b))}
