;; luajit, ported from its plan.sh.
{:name "luajit"
 :origin "karate"
 :version "2.0.5"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "LuaJIT is a Just-In-Time (JIT) compiler for the Lua programming language."
 :upstream_url "http://luajit.org/"
 :source {:url "http://luajit.org/download/LuaJIT-2.0.5.tar.gz" :sha256 "874b1f8297c697821f561f9b73b57ffd419ed8f4278c82e05b48806d30c1e979" :dirname "LuaJIT-2.0.5"}
 :deps ["karate/glibc" "karate/gcc-libs"]
 :build_deps ["karate/gcc" "karate/make"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :prepare (fn [b]
          (b:env "TARGET_CFLAGS" (or (b:getenv "CFLAGS") ""))
          (b:env "TARGET_LDFLAGS" (or (b:getenv "CFLAGS") "")))
 :build (fn [b]
          (b:run ["make"]))
 :install (fn [b]
          (b:run ["make" "V=1" (.. "PREFIX=" b.prefix) "install"]))}
