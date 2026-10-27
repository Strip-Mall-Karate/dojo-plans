;; libwebp, ported from its plan.sh.
(fn use-dependency-path [b path replacement]
  ;; The source project's studio linked a dependency's tool to `path` for the
  ;; build. A Dojo build writes nothing outside itself, so the build's scripts
  ;; name the dependency's tool instead.
  (each [_ f (ipairs (b:find b.src "*"))]
    (let [name (: f :match "[^/]+$")]
      (when (and (or (: name :match :^configure) (: name :match :^Makefile)
                     (: name :match :^ltmain) (: name :match "%.in$")
                     (: name :match "%.am$") (: name :match "%.ac$")
                     (: name :match "%.m4$") (: name :match "%.mk$")
                     (: name :match "%.sh$") (: name :match "%.pl$")
                     (: name :match "%.py$"))
                 (not (b:exists (b:join f "."))))
        (let [text (b:read f)
              escaped (pick-values 1
                                   (: path :gsub "[%^%$%(%)%%%.%[%]%*%+%-%?]"
                                      "%%%0"))
              (fixed n) (: text :gsub escaped
                           (pick-values 1 (: replacement :gsub "%%" "%%%%")))]
          (when (> n 0) (b:write f fixed)))))))

{:name :libwebp
 :origin :karate
 :version :0.5.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:WebM]
 :description "WebP codec: library to encode and decode images in WebP format."
 :upstream_url "https://developers.google.com/speed/webp"
 :source {:url "https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-0.5.1.tar.gz"
          :sha256 :6ad66c6fcd60a023de20b6856b03da8c7d347269d76b1fd9c3287e8b5e8813df}
 :deps [:karate/giflib
        :karate/glibc
        :karate/libjpeg-turbo
        :karate/jbigkit
        :karate/libpng
        :karate/libtiff
        :karate/xz
        :karate/zlib]
 :build_deps [:karate/gcc :karate/file :karate/make]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :prepare (fn [b]
            (use-dependency-path b :/usr/bin/file (b:path_for :file :bin/file)))
 :build (fn [b]
          (b:run [:./configure
                  (.. :--prefix= b.prefix)
                  :--enable-libwebpmux
                  :--enable-libwebpdemux
                  :--enable-libwebpdecoder])
          (b:run [:make]))
 :strip (fn [b]
          (b.default.strip b)
          ;; From do_end.
          )}
