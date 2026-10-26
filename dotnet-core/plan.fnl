;; dotnet-core, ported from its plan.sh.
{:name "dotnet-core"
 :origin "karate"
 :version "2.2.3"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description ".NET Core is a blazing fast, lightweight and modular platform\nfor creating web applications and services that run on Windows,\nLinux and Mac."
 :upstream_url "https://www.microsoft.com/net/core"
 :source {:url "https://download.visualstudio.microsoft.com/download/pr/28271651-a8f6-41d6-9144-2d53f6c4aac4/bb29124818f370cd08c5c8cc8f8816bf/dotnet-runtime-2.2.3-linux-x64.tar.gz" :sha256 "ae4aeb1e96c447b59ee9e9a2d08b6c9ec7a82bc06222819828ec165d704f05e8" :filename "dotnet-debian-x64.2.2.3.tar.gz"}
 :deps ["karate/curl" "karate/gcc-libs" "karate/glibc" "karate/icu52" "karate/krb5" "karate/libunwind" "karate/lttng-ust" "karate/openssl" "karate/util-linux" "karate/zlib"]
 :build_deps ["karate/patchelf"]
 :bin_dirs ["bin"]
 :unpack (fn [b]
          (b:mkdir (.. b.cache "/" (.. b.name "-" b.version)))
          (b:run ["tar" "xf" (.. b.cache "/dotnet-debian-x64.2.2.3.tar.gz") "-C" (.. b.cache "/" (.. b.name "-" b.version)) "--no-same-owner"]))
 :prepare (fn [b]
          (b:run ["find" "." "-type" "f" "-name" "dotnet" "-exec" "patchelf" "--interpreter" (.. (b:path_for "glibc") "/lib/ld-linux-x86-64.so.2") "--set-rpath" (or (b:getenv "LD_RUN_PATH") "") "{}" ";"])
          (b:run ["find" "." "-type" "f" "-name" "*.so*" "-exec" "patchelf" "--set-rpath" (or (b:getenv "LD_RUN_PATH") "") "{}" ";"]))
 :build (fn [b]
          nil)
 :install (fn [b]
          (if (b:exists (.. b.prefix "/bin"))
            (b:copy b.src (b:join (.. b.prefix "/bin") (: b.src :match "[^/]+$")))
            (b:copy b.src (.. b.prefix "/bin")))
          (b:chmod (b:join b.src "-R") "o+r")
          (b:chmod (.. b.prefix "/bin") "o+r")
          (if (b:exists (.. b.prefix "/LICENSE.txt"))
            (b:move (.. b.prefix "/bin/LICENSE.txt") (b:join (.. b.prefix "/LICENSE.txt") (: (.. b.prefix "/bin/LICENSE.txt") :match "[^/]+$")))
            (b:move (.. b.prefix "/bin/LICENSE.txt") (.. b.prefix "/LICENSE.txt")))
          (if (b:exists (.. b.prefix "/ThirdPartyNotices.txt"))
            (b:move (.. b.prefix "/bin/ThirdPartyNotices.txt") (b:join (.. b.prefix "/ThirdPartyNotices.txt") (: (.. b.prefix "/bin/ThirdPartyNotices.txt") :match "[^/]+$")))
            (b:move (.. b.prefix "/bin/ThirdPartyNotices.txt") (.. b.prefix "/ThirdPartyNotices.txt"))))
 :strip (fn [b]
          nil)}
