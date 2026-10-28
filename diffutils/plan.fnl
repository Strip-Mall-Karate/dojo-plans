;; diffutils, ported from its plan.sh.
;; diffutils 3.12, the latest release on 2026-10-26.
{:name :diffutils
 :origin :karate
 :version :3.12
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:gplv3+]
 :description "GNU Diffutils is a package of several programs related to finding differences between files."
 :upstream_url "https://www.gnu.org/software/diffutils"
 :source {:url "https://ftp.gnu.org/gnu/diffutils/diffutils-3.12.tar.xz"
          :sha256 :7c8b7f9fc8609141fdea9cece85249d308624391ff61dedaf528fcb337727dfd}
 :deps [:karate/glibc]
 :build_deps [:karate/coreutils
              :karate/patch
              :karate/make
              :karate/gcc
              :karate/sed]
 :bin_dirs [:bin]
 :build (fn [b]
          (b:write (b:join b.src :config.cache)
                   (.. (if (b:exists (b:join b.src :config.cache))
                           (b:read (b:join b.src :config.cache))
                           "") "gl_cv_func_getopt_gnu=yes
"))
          (b:run [:./configure
                  (.. :--prefix= b.prefix)
                  :--cache-file=config.cache])
          (b:run [:make]))
 :check (fn [b]
          (let [text (b:read (b:join b.src :build-aux/update-copyright))
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
                                  (string.gsub line "copyright{" "copyright\\{"
                                               1))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join b.src :build-aux/update-copyright)
                     (.. (table.concat out "\n")
                         (if (and ends (> (length out) 0))
                             "\n"
                             ""))))
          (b:run [:make
                  :check
                  (.. :PATH= (b:capture [:pwd]) "/src:"
                      (or (b:getenv :PATH) ""))]))}
