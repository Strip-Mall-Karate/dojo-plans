;; openjdk11, ported from its plan.sh.
{:name :openjdk11
 :origin :karate
 :version :11.0.2
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-2.0-only]
 :upstream_url "https://openjdk.java.net/"
 :source {:url "https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz"
          :sha256 :99be79935354f5c0df1ad293620ea36d13f48ec3ea870c838f20c504c9668b57
          :filename :openjdk-11.0.2_linux-x64_bin.tar.gz
          :dirname :jdk-11.0.2}
 :deps [:karate/alsa-lib
        :karate/freetype
        :karate/gcc-libs
        :karate/glibc
        :karate/libxext
        :karate/libxi
        :karate/libxrender
        :karate/libxtst
        :karate/xlib
        :karate/zlib]
 :build_deps [:karate/patchelf :karate/rsync]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :prepare (fn [b]
            ;; From do_setup_environment.
            (b:runtime_env :JAVA_HOME b.prefix)
            (b.default.prepare b))
 :build (fn [_b]
          nil)
 :install (fn [b]
            (b:run [:rsync :-avz (.. b.cache :/jdk-11.0.2 "/") "."]
                   {:cwd b.prefix})
            (b:env :LD_RUN_PATH
                   (.. (or (b:getenv :LD_RUN_PATH) "") ":" b.prefix "/lib/jli:"
                       b.prefix "/lib/server:" b.prefix :/lib))
            (b:log (.. "Setting interpreter for all executables to '"
                       (b:path_for :glibc) "/lib/ld-linux-x86-64.so.2'"))
            (b:log (.. "Setting rpath for all libraries to '"
                       (or (b:getenv :LD_RUN_PATH) "") "'"))
            (b:run [:find
                    (.. b.prefix :/bin)
                    :-type
                    :f
                    :-executable
                    :-exec
                    :sh
                    :-c
                    "file -i \"$1\" | grep -q \"x-executable; charset=binary\""
                    "_"
                    "{}"
                    ";"
                    :-exec
                    :patchelf
                    :--interpreter
                    (.. (b:path_for :glibc) :/lib/ld-linux-x86-64.so.2)
                    :--set-rpath
                    (or (b:getenv :LD_RUN_PATH) "")
                    "{}"
                    ";"] {:cwd b.prefix})
            (b:run [:find
                    (.. b.prefix :/lib)
                    :-type
                    :f
                    :-name
                    :*.so
                    :-exec
                    :patchelf
                    :--set-rpath
                    (or (b:getenv :LD_RUN_PATH) "")
                    "{}"
                    ";"] {:cwd b.prefix}))
 :strip (fn [_b]
          nil)}
