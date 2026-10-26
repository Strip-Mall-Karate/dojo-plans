;; jre7, ported from its plan.sh.
{:name "jre7"
 :origin "karate"
 :version "7u80"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Oracle Binary Code License Agreement for the Java SE Platform Products and JavaFX"]
 :upstream_url "http://www.oracle.com/technetwork/java/javase/overview/index.html"
 :source {:url "https://www.dropbox.com/s/77b7n7wkjzpzhfd/jre-7u80-linux-x64.tar.gz" :sha256 "4c01efd0d8e80bb6e2f324ec3408ce64f066d4506c7ec93a491f615a4523f4f3" :filename "jre-7u80-linux-x64.tar.gz"}
 :deps ["karate/glibc" "karate/gcc-libs"]
 :build_deps ["karate/patchelf"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :unpack (fn [b]
          (var v-unpack-file "")
          (set v-unpack-file (.. b.cache "/jre-7u80-linux-x64.tar.gz"))
          (b:mkdir (b:join b.src "@{cache}/jre7-7u80"))
          (b:run ["tar" "xz" "--strip-components=1" "-f" v-unpack-file] {:cwd "@{cache}/jre7-7u80"}))
 :prepare (fn [b]
          ;; From do_setup_environment.
          (b:run ["set_runtime_env" "JAVA_HOME" b.prefix])
          (b.default.prepare b))
 :build (fn [b]
          nil)
 :install (fn [b]
          (each [_ p (ipairs (b:glob (b:join b.src "@{cache}/jre7-7u80") "*"))] (b:copy p (b:join b.prefix (: p :match "[^/]+$"))))
          (b:log (.. "Setting interpreter for '" b.prefix "/bin/java' '" (b:path_for "glibc") "/lib/ld-linux-x86-64.so.2'"))
          (b:log (.. "Setting rpath for '" b.prefix "/bin/java' to '" (or (b:getenv "LD_RUN_PATH") "") "'"))
          (b:env "LD_RUN_PATH" (.. (or (b:getenv "LD_RUN_PATH") "") ":" b.prefix "/lib/amd64/jli:" b.prefix "/lib/amd64/server:" b.prefix "/lib/amd64"))
          (b:run ["find" (.. b.prefix "/bin") "-type" "f" "-executable" "-exec" "sh" "-c" "file -i \"$1\" | grep -q \"x-executable; charset=binary\"" "_" "{}" ";" "-exec" "patchelf" "--interpreter" (.. (b:path_for "glibc") "/lib/ld-linux-x86-64.so.2") "--set-rpath" (or (b:getenv "LD_RUN_PATH") "") "{}" ";"] {:cwd "@{cache}/jre7-7u80"})
          (b:run ["find" (.. b.prefix "/lib/amd64") "-name" "*.so" "-type" "f" "-exec" "patchelf" "--set-rpath" (or (b:getenv "LD_RUN_PATH") "") "{}" ";"] {:cwd "@{cache}/jre7-7u80"}))
 :strip (fn [b]
          nil)}
