;; phantomjs, ported from its plan.sh.
{:name :phantomjs
 :origin :karate
 :version :2.1.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:bsd]
 :source {:url "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2"
          :sha256 :86dd9a4bf4aee45f1a84c9f61cf1947c1d6dce9b9e8d2a907105da7852460d2f
          :filename :phantomjs-2.1.1-linux-x86_64.tar.bz2
          :dirname :phantomjs-2.1.1-linux-x86_64}
 :deps [:karate/glibc
        :karate/freetype
        :karate/fontconfig
        :karate/zlib
        :karate/libpng
        :karate/expat
        :karate/gcc-libs]
 :build_deps [:karate/curl :karate/cacerts :karate/patchelf]
 :bin_dirs [:bin]
 :download (fn [b]
             ;; The plan downloaded with curl because bitbucket refused its wget; b's
             ;; download is curl's, checked against the source's SHA-256.
             (b.default.download b))
 :build (fn [_b]
          nil)
 :install (fn [b]
            (each [_ p (ipairs (b:glob b.src "*"))]
              (b:copy p (b:join b.prefix (p:match "[^/]+$"))))
            (b:log (.. "Setting interpreter for '" b.prefix "/bin/phantomjs' '"
                       (b:path_for :glibc) "/lib/ld-linux-x86-64.so.2'"))
            (b:log (.. "Setting rpath for '" b.prefix "/bin/phantomjs' to '"
                       (or (b:getenv :LD_RUN_PATH) "") "'"))
            (b:run [:patchelf
                    :--interpreter
                    (.. (b:path_for :glibc) :/lib/ld-linux-x86-64.so.2)
                    :--set-rpath
                    (or (b:getenv :LD_RUN_PATH) "")
                    (.. b.prefix :/bin/phantomjs)]))
 :strip (fn [_b]
          nil)}
