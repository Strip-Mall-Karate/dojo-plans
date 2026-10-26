;; jdk7, ported from its plan.sh.
{:name "jdk7"
 :origin "karate"
 :version "7u80"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Oracle Binary Code License Agreement for the Java SE Platform Products and JavaFX"]
 :upstream_url "http://www.oracle.com/technetwork/java/javase/overview/index.html"
 :source {:url "https://www.dropbox.com/s/lni4xcu2eqhqjq9/jdk-7u80-linux-x64.tar.gz" :sha256 "bad9a731639655118740bee119139c1ed019737ec802a630dd7ad7aab4309623" :filename "jdk-7u80-linux-x64.tar.gz"}
 :deps ["karate/glibc" "karate/gcc-libs"]
 :build_deps ["karate/patchelf" "karate/file"]
 :bin_dirs ["bin" "jre/bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :unpack (fn [b]
          (var v-unpack-file "")
          (b:log "By including the JDK you accept the terms of the Oracle Binary Code License Agreement for the Java SE Platform Products and JavaFX, which can be found at http://www.oracle.com/technetwork/java/javase/terms/license/index.html")
          (set v-unpack-file (.. b.cache "/jdk-7u80-linux-x64.tar.gz"))
          (b:mkdir (b:join b.src "@{cache}/jdk7-7u80"))
          (b:run ["tar" "xz" "--strip-components=1" "-f" v-unpack-file] {:cwd "@{cache}/jdk7-7u80"}))
 :prepare (fn [b]
          ;; From do_setup_environment.
          (b:run ["set_runtime_env" "JAVA_HOME" b.prefix])
          (b.default.prepare b))
 :build (fn [b]
          nil)
 :install (fn [b]
          (each [_ p (ipairs (b:glob (b:join b.src "@{cache}/jdk7-7u80") "*"))] (b:copy p (b:join b.prefix (: p :match "[^/]+$"))))
          (b:log (.. "Setting interpreter for '" b.prefix "/bin/java' '" (b:path_for "glibc") "/lib/ld-linux-x86-64.so.2'"))
          (b:log (.. "Setting rpath for '" b.prefix "/bin/java' to '" (or (b:getenv "LD_RUN_PATH") "") "'"))
          (b:env "LD_RUN_PATH" (.. (or (b:getenv "LD_RUN_PATH") "") ":" b.prefix "/lib/amd64/jli:" b.prefix "/lib/amd64:" b.prefix "/jre/lib/amd64/jli:" b.prefix "/jre/lib/amd64"))
          (b:run ["find" (.. b.prefix "/bin") (.. b.prefix "/jre/bin") "-type" "f" "-executable" "-exec" "sh" "-c" "file -i \"$1\" | grep -q \"x-executable; charset=binary\"" "_" "{}" ";" "-exec" "patchelf" "--interpreter" (.. (b:path_for "glibc") "/lib/ld-linux-x86-64.so.2") "--set-rpath" (or (b:getenv "LD_RUN_PATH") "") "{}" ";"] {:cwd "@{cache}/jdk7-7u80"})
          (b:run ["find" (.. b.prefix "/jre/lib/amd64") "-type" "f" "-exec" "patchelf" "--set-rpath" (or (b:getenv "LD_RUN_PATH") "") "{}" ";"] {:cwd "@{cache}/jdk7-7u80"})
          (b:run ["find" (.. b.prefix "/lib/amd64/jli") "-name" "*.so" "-type" "f" "-exec" "patchelf" "--set-rpath" (or (b:getenv "LD_RUN_PATH") "") "{}" ";"] {:cwd "@{cache}/jdk7-7u80"}))
 :strip (fn [b]
          nil)}
