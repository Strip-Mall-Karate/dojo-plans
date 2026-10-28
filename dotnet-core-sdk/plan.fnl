;; dotnet-core-sdk, ported from its plan.sh.
{:name :dotnet-core-sdk
 :origin :karate
 :version :2.2.202
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description ".NET Core is a blazing fast, lightweight and modular platform
for creating web applications and services that run on Windows,
Linux and Mac."
 :upstream_url "https://www.microsoft.com/net/core"
 :source {:url "https://download.visualstudio.microsoft.com/download/pr/2cecc1f4-5c77-4a9f-a2fa-8bfcee4d4bf0/4e68e8e0e0aac72711eb34c3a9988e45/dotnet-sdk-2.2.202-linux-x64.tar.gz"
          :sha256 :3e3fdf2e6c8053a87f07c16f6e9c55d1be6d28d8273a67cce3207a9f58c14de1
          :filename :dotnet-dev-debian-x64.2.2.202.tar.gz}
 :deps [:karate/coreutils
        :karate/curl
        :karate/gcc-libs
        :karate/glibc
        :karate/icu52
        :karate/krb5
        :karate/libunwind
        :karate/lttng-ust
        :karate/openssl
        :karate/util-linux
        :karate/zlib]
 :build_deps [:karate/patchelf]
 :bin_dirs [:bin]
 :unpack (fn [b]
           (b:mkdir (.. b.cache "/" b.name "-" b.version))
           (b:run [:tar
                   :xf
                   (.. b.cache :/dotnet-dev-debian-x64.2.2.202.tar.gz)
                   :-C
                   (.. b.cache "/" b.name "-" b.version)
                   :--no-same-owner]))
 :prepare (fn [b]
            (b:run [:find
                    "."
                    :-type
                    :f
                    :-name
                    :dotnet
                    :-exec
                    :patchelf
                    :--interpreter
                    (.. (b:path_for :glibc) :/lib/ld-linux-x86-64.so.2)
                    :--set-rpath
                    (or (b:getenv :LD_RUN_PATH) "")
                    "{}"
                    ";"])
            (b:run [:find
                    "."
                    :-type
                    :f
                    :-name
                    :*.so*
                    :-exec
                    :patchelf
                    :--set-rpath
                    (or (b:getenv :LD_RUN_PATH) "")
                    "{}"
                    ";"])
            (b:fix_interpreter [(.. b.cache "/" b.name "-" b.version :/sdk/
                                    b.version :/Roslyn/RunCsc.sh)]
                               :karate/coreutils :bin/env))
 :build (fn [_b]
          nil)
 :check (fn [b]
          (b:mkdir (b:join b.src :dotnet-new))
          (b:run [:../dotnet :new] {:cwd :dotnet-new})
          (b:remove (b:join b.src :dotnet-new)))
 :install (fn [b]
            (if (b:exists (.. b.prefix :/bin))
                (b:copy b.src
                        (b:join (.. b.prefix :/bin) (b.src:match "[^/]+$")))
                (b:copy b.src (.. b.prefix :/bin)))
            (b:chmod (b:join b.src :-R) :o+r)
            (b:chmod (.. b.prefix :/bin) :o+r))
 :strip (fn [_b]
          nil)}
