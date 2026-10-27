;; kubernetes, ported from its plan.sh.
{:name :kubernetes
 :origin :karate
 :version :1.11.2
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0]
 :description "Production-Grade Container Scheduling and Management"
 :upstream_url "https://github.com/kubernetes/kubernetes"
 :source {:url "https://github.com/kubernetes/kubernetes/archive/v1.11.2.tar.gz"
          :sha256 :43f42c64426247d909010bf77f18c72ab1f36104a67e9c878cf897ee9f0ab6a6}
 :deps [:karate/glibc :karate/coreutils]
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
            (b:fix_interpreter (icollect [p (: (b:capture [:find
                                                           :hack
                                                           :-name
                                                           :*.sh])
                                               :gmatch "%S+")]
                                 (if (= (p:sub 1 1) "/") p (b:join b.src p)))
                               :karate/coreutils :bin/env))
 :build (fn [b]
          (b:run [:make]))
 :install (fn [b]
            (each [_ p (ipairs (b:glob (b:join b.src :_output/bin) "*"))]
              (b:copy p (b:join (.. b.prefix :/bin) (: p :match "[^/]+$")))))}
