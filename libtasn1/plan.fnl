;; libtasn1, ported from its plan.sh.
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

{:name :libtasn1
 :origin :karate
 :version :4.13
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:LGPL-2.1-or-later]
 :description "ASN.1 implementation"
 :upstream_url "https://www.gnu.org/software/libtasn1/"
 :source {:url "https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.13.tar.gz"
          :sha256 :7e528e8c317ddd156230c4e31d082cd13e7ddeb7a54824be82632209550c8cca}
 :deps [:karate/glibc]
 :build_deps [:karate/bison
              :karate/busybox-static
              :karate/diffutils
              :karate/file
              :karate/gcc
              :karate/make
              :karate/pkg-config
              :karate/util-linux]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]
 :prepare (fn [b]
            (use-dependency-path b :/usr/bin/file (b:path_for :file :bin/file)))
 :check (fn [b]
          (b:run [:make :check]))
 :strip (fn [b]
          (b.default.strip b)
          ;; From do_end.
          )}
