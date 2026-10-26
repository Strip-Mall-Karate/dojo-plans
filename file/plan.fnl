;; file, ported from its plan.sh.
{:name "file"
 :origin "karate"
 :version "5.34"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["custom"]
 :description "file is a standard Unix program for recognizing the type of data contained in a computer file."
 :upstream_url "https://www.darwinsys.com/file/"
 :source {:url "ftp://ftp.astron.com/pub/file/file-5.34.tar.gz" :sha256 "f15a50dbbfa83fec0bd1161e8e191b092ec832720e30cd14536e044ac623b20a"}
 :deps ["karate/glibc" "karate/zlib"]
 :build_deps ["karate/coreutils" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :prepare (fn [b]
          (var v-dynamic-linker "")
          (b.default.prepare b)
          (set v-dynamic-linker (.. (b:path_for "glibc") "/lib/ld-linux-x86-64.so.2"))
          (b:env "LDFLAGS" (.. (or (b:getenv "LDFLAGS") "") " -Wl,-rpath=" (or (b:getenv "LD_RUN_PATH") "") ",--enable-new-dtags"))
          (b:env "LDFLAGS" (.. (or (b:getenv "LDFLAGS") "") " -Wl,--dynamic-linker=" v-dynamic-linker))
          (b:log (.. "Updating LDFLAGS=" (or (b:getenv "LDFLAGS") ""))))
 :check (fn [b]
          (b:run ["make" "check"]))
 :install (fn [b]
          (b:run ["make" "install"])
          (b:copy (b:join b.src "COPYING") (.. b.prefix "/share/COPYING"))
          (b:chmod (.. b.prefix "/share/COPYING") "644"))}
