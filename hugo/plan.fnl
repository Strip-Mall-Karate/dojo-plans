;; hugo, ported from its plan.sh.
{:name :hugo
 :origin :karate
 :version :0.55.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0]
 :description "Hugo is one of the most popular open-source static site generators."
 :upstream_url "https://gohugo.io"
 :deps [:karate/glibc]
 :build_deps [:karate/go :karate/git :karate/gcc]
 :bin_dirs [:bin]
 :build (fn [b]
          (var v-hugo-dir "")
          (set v-hugo-dir (.. b.cache :/hugo- b.version))
          (b:run [:git
                  :clone
                  :--depth
                  :1
                  :--branch
                  (.. :v b.version)
                  :--config
                  :advice.detachedHead=false
                  "https://github.com/gohugoio/hugo.git"
                  v-hugo-dir])
          (b:run [:go :install :--tags :extended] {:cwd v-hugo-dir})
          (b:run [:go :build :-o :hugo :main.go] {:cwd v-hugo-dir}))
 :install (fn [b]
            (b:copy (.. b.cache :/hugo- b.version :/hugo)
                    (b:join (.. b.prefix :/bin/)
                            (: (.. b.cache :/hugo- b.version :/hugo) :match
                               "[^/]+$"))))}
