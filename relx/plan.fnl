;; relx, ported from its plan.sh.
{:name :relx
 :origin :karate
 :version :3.29.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0]
 :description "A release assembler for Erlang."
 :upstream_url "https://github.com/erlware/relx"
 :source {:url "https://github.com/erlware/relx/archive/v3.29.0.tar.gz"
          :sha256 :d64eca52e17ba3c6ffde695900054eb5ad8e679fd1f941981d85711664b0305f}
 :deps [:karate/erlang :karate/coreutils]
 :build_deps [:karate/rebar3]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :build (fn [b]
          (b:run [:rebar3 :update])
          (b:run [:rebar3 :escriptize]))
 :install (fn [b]
            (each [_ p (ipairs (b:glob (b:join b.src :_build/default) "*"))]
              (b:copy p (b:join b.prefix (p:match "[^/]+$"))))
            (b:chmod (.. b.prefix :/bin/relx) :+x)
            (b:fix_interpreter [(.. b.prefix :/bin/relx)] :karate/coreutils
                               :bin/env))}
