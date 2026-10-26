;; dotnet-asp-core, ported from its plan.sh.
{:name "dotnet-asp-core"
 :origin "karate"
 :version "2.2.3"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "ASP.NET Core is a cross-platform, high-performance, open-source framework for building modern, cloud-based, Internet-connected applications."
 :upstream_url "https://docs.microsoft.com/en-us/aspnet/core"
 :source {:url "https://download.visualstudio.microsoft.com/download/pr/dabca6d9-19e5-44b6-a402-a627fae42d26/e36d703f5d281ec8662422bfa62c2fdd/aspnetcore-runtime-2.2.3-linux-x64.tar.gz" :sha256 "9d71c8312ec3448ae957cfbf4d4777c1924e34cb287d0f0d0f4853ce4ffc5355" :filename "aspnetcore-runtime-2.2.3-linux-x64.tar.gz"}
 :deps ["karate/curl" "karate/gcc-libs" "karate/glibc" "karate/icu52" "karate/krb5" "karate/libunwind" "karate/lttng-ust" "karate/openssl" "karate/util-linux" "karate/zlib"]
 :build_deps ["karate/patchelf"]
 :bin_dirs ["bin"]
 :unpack (fn [b]
          (b:mkdir (.. b.cache "/" (.. b.name "-" b.version)))
          (b:run ["tar" "xf" (.. b.cache "/aspnetcore-runtime-2.2.3-linux-x64.tar.gz") "-C" (.. b.cache "/" (.. b.name "-" b.version)) "--no-same-owner"]))
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
