;; luajit, ported from its plan.sh.
;; luajit 2.1.1792588164, the v2.1 branch head (a4c0645) on 2026-10-27, LuaJIT tags no releases: 2.0.5's source no longer downloads.
{:name "luajit"
 :origin "karate"
 :version "2.1.1792588164"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "LuaJIT is a Just-In-Time (JIT) compiler for the Lua programming language."
 :upstream_url "https://luajit.org/"
 :source {:url "https://github.com/LuaJIT/LuaJIT/archive/a4c064539ea931274d407e1249b4bb575424a0f4.tar.gz" :sha256 "15625df3ebfbd1f76371005bffae39b84c65e718e57acc9a9c57863c7c101541" :filename "LuaJIT-a4c064539ea931274d407e1249b4bb575424a0f4.tar.gz" :dirname "LuaJIT-a4c064539ea931274d407e1249b4bb575424a0f4"}
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
