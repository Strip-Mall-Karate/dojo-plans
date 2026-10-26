;; lua, ported from its plan.sh.
{:name "lua"
 :origin "karate"
 :version "5.3.4"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "A powerful, efficient, lightweight, embeddable scripting language"
 :upstream_url "https://www.lua.org/"
 :source {:url "https://www.lua.org/ftp/lua-5.3.4.tar.gz" :sha256 "f681aa518233bc407e23acf0f5887c884f17436f000d453b2491a9f11a52400c"}
 :deps ["karate/glibc" "karate/readline"]
 :build_deps ["karate/gcc" "karate/make"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["make" "linux" (.. "MYCFLAGS=" (or (b:getenv "CFLAGS") "") " -fPIC") (.. "MYLDFLAGS=" (or (b:getenv "LDFLAGS") "")) (.. "INSTALL_TOP=" b.prefix)]))
 :check (fn [b]
          (b:run ["make" "test"]))
 :install (fn [b]
          (b:run ["make" "install" (.. "INSTALL_TOP=" b.prefix)]))}
