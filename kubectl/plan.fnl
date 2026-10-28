;; kubectl, ported from its plan.sh.
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

{:name :kubectl
 :origin :karate
 :version :1.11.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0]
 :description "kubectl CLI tool"
 :upstream_url "https://github.com/kubernetes/kubernetes"
 :source {:url "https://github.com/kubernetes/kubernetes/archive/v1.11.1.tar.gz"
          :sha256 :073b77321812f26df6513c0ad0aef3a8b0c17f6281a186d515f5855ae009ea17
          :dirname :kubernetes-1.11.1}
 :deps [:karate/glibc]
 :build_deps [:karate/git
              :karate/make
              :karate/gcc
              :karate/go
              :karate/diffutils
              :karate/which
              :karate/rsync
              :karate/coreutils]
 :bin_dirs [:bin]
 :prepare (fn [b]
            (use-dependency-path b :/usr/bin/env
                                 (b:path_for :coreutils :bin/env)))
 :build (fn [b]
          (b:run [:make :kubectl]))
 :install (fn [b]
            (b:copy (b:join b.src :_output/bin/kubectl)
                    (b:join (.. b.prefix :/bin/)
                            (: (b:join b.src :_output/bin/kubectl) :match
                               "[^/]+$"))))
 :strip (fn [b]
          (b.default.strip b)
          ;; From do_end.
          )}
