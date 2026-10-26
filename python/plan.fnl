;; python, ported from its plan.sh.
{:name "python"
 :origin "karate"
 :version "3.7.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Python-2.0"]
 :description "Python is a programming language that lets you work quickly and integrate systems more effectively."
 :upstream_url "https://www.python.org"
 :source {:url "https://www.python.org/ftp/python/3.7.0/Python-3.7.0.tgz" :sha256 "85bb9feb6863e04fb1700b018d9d42d1caac178559ffa453d7e6a436e259fd0d" :dirname "Python-3.7.0"}
 :deps ["karate/bzip2" "karate/expat" "karate/gcc-libs" "karate/gdbm" "karate/glibc" "karate/libffi" "karate/ncurses" "karate/openssl" "karate/readline" "karate/sqlite" "karate/zlib"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/gcc" "karate/linux-headers" "karate/make" "karate/util-linux"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :interpreters ["bin/python" "bin/python3" "bin/python3.7"]
 :prepare (fn [b]
          (let [text (b:read (b:join b.src "Modules/Setup.dist")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (set line (pick-values 1 (string.gsub line "#zlib" "zlib" 1))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join b.src "Modules/Setup.dist") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" ""))))
          (let [text (b:read (b:join b.src "Modules/Setup.dist")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (when (or (string.find line "SSL=") (string.find line "_ssl") (string.find line "%-DUSE_SSL") (string.find line "%-lssl")) (set line (pick-values 1 (string.gsub line "^#" "" 1)))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join b.src "Modules/Setup.dist") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" "")))))
 :build (fn [b]
          (b:env "LDFLAGS" (.. (or (b:getenv "LDFLAGS") "") " -lgcc_s"))
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--enable-loadable-sqlite-extensions" "--enable-shared" "--with-threads" "--with-system-expat" "--with-system-ffi" "--with-ensurepip"])
          (b:run ["make"]))
 :check (fn [b]
          (b:run ["make" "test"]))
 :install (fn [b]
          (var v-major "")
          (var v-minor "")
          (var v-platlib "")
          (b.default.install b)
          (set v-minor "3.7")
          (set v-major "3")
          (b:symlink (: (.. b.prefix "/bin/pip" v-minor) :match "[^/]+$") (.. b.prefix "/bin/pip"))
          (b:symlink (: (.. b.prefix "/bin/pydoc" v-minor) :match "[^/]+$") (.. b.prefix "/bin/pydoc"))
          (b:symlink (: (.. b.prefix "/bin/python" v-minor) :match "[^/]+$") (.. b.prefix "/bin/python"))
          (b:symlink (: (.. b.prefix "/bin/python" v-minor "-config") :match "[^/]+$") (.. b.prefix "/bin/python-config"))
          (b:remove (.. b.prefix "/bin/idle" v-major))
          (b:remove (.. b.prefix "/bin/idle" v-minor))
          (set v-platlib (b:capture ["python" "-c" "import sysconfig;print(sysconfig.get_path('platlib'))"]))
          (b:write (.. v-platlib "/_manylinux.py") "# Disable binary manylinux1(CentOS 5) wheel support\nmanylinux1_compatible = False\n"))}
