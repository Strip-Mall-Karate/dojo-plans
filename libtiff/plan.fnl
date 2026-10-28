;; libtiff, ported from its plan.sh.
{:name :libtiff
 :origin :karate
 :version :4.0.6
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:libtiff]
 :description "Library for reading and writting files in the Tag Image File Format (TIFF)"
 :upstream_url "http://www.remotesensing.org/libtiff/"
 :source {:url "http://download.osgeo.org/libtiff/tiff-4.0.6.tar.gz"
          :sha256 :4d57a50907b510e3049a4bba0d7888930fdfc16ce49f1bf693e5b6247370d68c
          :dirname :tiff-4.0.6}
 :deps [:karate/glibc
        :karate/zlib
        :karate/libjpeg-turbo
        :karate/xz
        :karate/jbigkit]
 :build_deps [:karate/gcc :karate/make :karate/diffutils :karate/file]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :prepare (fn [b]
            (var v--file-path "")
            (set v--file-path (.. (b:path_for :file) :/bin/file))
            (let [text (b:read (b:join b.src :configure))
                  ends (= (text:sub -1) "\n")
                  lines []
                  out []]
              (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")]
                (table.insert lines l))
              (each [_n l (ipairs lines)]
                (var line l)
                (local deleted false)
                (local after [])
                (when (not deleted)
                  (set line
                       (pick-values 1
                                    (string.gsub line :/usr/bin/file
                                                 (pick-values 1
                                                              (v--file-path:gsub "%%"
                                                                                 "%%%%"))))))
                (when (not deleted) (table.insert out line))
                (each [_ x (ipairs after)] (table.insert out x)))
              (b:write (b:join b.src :configure)
                       (.. (table.concat out "\n")
                           (if (and ends (> (length out) 0))
                               "\n"
                               "")))))
 :check (fn [b]
          (b:run [:make :check]))}
