;; rkt, ported from its plan.sh.
{:name :rkt
 :origin :karate
 :version :1.29.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2]
 :description "rkt - the pod native container engine"
 :upstream_url "https://github.com/rkt/rkt/releases"
 :source {:url "https://github.com/rkt/rkt/releases/download/v1.29.0/rkt-v1.29.0.tar.gz"
          :sha256 :4fdd3d46aa58a9e7a7d1c36a7cb390ea96fd297b694295eb79b8c185dbc73e7e
          :dirname :rkt-v1.29.0}
 :deps [:karate/gnupg :karate/glibc]
 :build_deps [:karate/patchelf]
 :bin_dirs [:bin]
 :build (fn [_b]
          nil)
 :install (fn [b]
            (b:copy (b:join b.src :rkt) (.. b.prefix :/bin/rkt))
            (b:chmod (.. b.prefix :/bin/rkt) :755)
            (b:run [:patchelf
                    :--interpreter
                    (.. (b:path_for :glibc) :/lib/ld-linux-x86-64.so.2)
                    :--set-rpath
                    (or (b:getenv :LD_RUN_PATH) "")
                    (.. b.prefix :/bin/rkt)]))
 :strip (fn [_b]
          nil)}
