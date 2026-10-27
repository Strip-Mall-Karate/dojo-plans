;; python2, ported from its plan.sh.
;; Python 2.7.18, the final 2.x release, compiled as C17: gcc 16 defaults to C23, where bool is a keyword.
;; Built from the python plan, with its own changes.
;; _ssl is not built in from Modules/Setup: Python 2.7 does not build against OpenSSL 3 or
;; later, and setup.py goes on without it.
{:name "python2"
 :origin "karate"
 :version "2.7.18"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Python-2.0"]
 :description "Python is a programming language that lets you work quickly and integrate systems more effectively."
 :upstream_url "https://www.python.org"
 :source {:url "https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tar.xz" :sha256 "b62c0e7937551d0cc02b8fd5cb0f544f9405bafc9a54d3808ed4594812edef43" :dirname "Python-2.7.18"}
 :deps ["karate/bzip2" "karate/expat" "karate/gcc-libs" "karate/gdbm" "karate/glibc" "karate/libffi" "karate/ncurses" "karate/openssl" "karate/readline" "karate/sqlite" "karate/zlib"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/gcc" "karate/linux-headers" "karate/make" "karate/util-linux"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :interpreters ["bin/python" "bin/python2" "bin/python2.7"]
 :prepare (fn [b]
          (let [text (b:read (b:join b.src "Modules/Setup.dist")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line "#zlib" "zlib" 1))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join b.src "Modules/Setup.dist") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" "")))))
 :build (fn [b]
          (b:env "CFLAGS" (.. (or (b:getenv "CFLAGS") "") " -std=gnu17"))
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--enable-shared" "--enable-unicode=ucs4" "--with-threads" "--with-system-expat" "--with-system-ffi" "--with-ensurepip"])
          (b:run ["make"]))
 :check (fn [b]
          (b:run ["make" "test"]))
 :install (fn [b]
          (var v-platlib "")
          (b.default.install b)
          (b:remove (.. b.prefix "/bin/idle"))
          ;; cgi.py is executable and names /usr/local/bin/python.
          (let [cgi (.. b.prefix "/lib/python2.7/cgi.py")]
            (b:write cgi (pick-values 1 (: (b:read cgi) :gsub "^#![^\n]*" (.. "#!" b.prefix "/bin/python2.7")))))
          (set v-platlib (b:capture ["python" "-c" "import sysconfig;print(sysconfig.get_path('platlib'))"]))
          (b:write (.. v-platlib "/_manylinux.py") "# Disable binary manylinux1(CentOS 5) wheel support\nmanylinux1_compatible = False\n"))}
