;; corretto8, ported from its plan.sh.
;; corretto8 8.512.08.1, the latest release on 2026-10-26: 8.202.08.2's source no longer downloads.
;; Built from the corretto plan, with its own changes.
{:name :corretto8
 :origin :karate
 :version :8.512.08.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-2.0-only]
 :upstream_url "https://aws.amazon.com/corretto/"
 :source {:url "https://corretto.aws/downloads/resources/8.512.08.1/amazon-corretto-8.512.08.1-linux-x64.tar.gz"
          :sha256 :da8cf8b796fbceb8a47c6f2c6071d8a5b285385e969750ab23e9ab8a52df3064
          :filename :amazon-corretto-8.512.08.1-linux-x64.tar.gz
          :dirname :amazon-corretto-8.512.08.1-linux-x64}
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
 :build (fn [b]
          nil)
 :install (fn [b]
            (b:run [:rsync
                    :-avz
                    (.. b.cache :/amazon-corretto-8.512.08.1-linux-x64/)
                    "."] {:cwd b.prefix})
            (b:env :LD_RUN_PATH
                   (.. (or (b:getenv :LD_RUN_PATH) "") ":" b.prefix
                       "/lib/amd64/jli:" b.prefix "/lib/server:" b.prefix
                       :/lib/amd64))
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
 :strip (fn [b]
          nil)}
