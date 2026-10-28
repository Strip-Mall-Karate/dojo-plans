;; libssh2, ported from its plan.sh.
(fn use-dependency-path [b path replacement]
  ;; The source project's studio linked a dependency's tool to `path` for the
  ;; build. A Dojo build writes nothing outside itself, so the build's scripts
  ;; name the dependency's tool instead.
  (each [_ f (ipairs (b:find b.src "*"))]
    (let [name (f:match "[^/]+$")]
      (when (and (or (name:match :^configure) (name:match :^Makefile)
                     (name:match :^ltmain) (name:match "%.in$")
                     (name:match "%.am$") (name:match "%.ac$")
                     (name:match "%.m4$") (name:match "%.mk$")
                     (name:match "%.sh$") (name:match "%.pl$")
                     (name:match "%.py$"))
                 (not (b:exists (b:join f "."))))
        (let [text (b:read f)
              escaped (pick-values 1
                                   (path:gsub "[%^%$%(%)%%%.%[%]%*%+%-%?]"
                                              "%%%0"))
              (fixed n) (text:gsub escaped
                                   (pick-values 1
                                                (replacement:gsub "%%" "%%%%")))]
          (when (> n 0) (b:write f fixed)))))))

{:name :libssh2
 :origin :karate
 :version :1.8.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:BSD-3-Clause]
 :description "libssh2 is a client-side C library implementing the SSH2 protocol"
 :upstream_url "https://libssh2.org/"
 :source {:url "https://libssh2.org/download/libssh2-1.8.0.tar.gz"
          :sha256 :39f34e2f6835f4b992cafe8625073a88e5a28ba78f83e8099610a7b3af4676d4}
 :deps [:karate/glibc :karate/openssl :karate/zlib]
 :build_deps [:karate/diffutils
              :karate/file
              :karate/gcc
              :karate/inetutils
              :karate/linux-headers
              :karate/make
              :karate/openssh
              :karate/pkg-config]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]
 :prepare (fn [b]
            (use-dependency-path b :/usr/bin/file (b:path_for :file :bin/file)))
 :check (fn [b]
          (b:run [:make :check] {:env {:USER :root}}))
 :strip (fn [b]
          (b.default.strip b)
          ;; From do_end.
          )}
