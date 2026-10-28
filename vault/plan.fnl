;; vault, ported from its plan.sh.
{:name :vault
 :origin :karate
 :version :1.1.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MPL-2.0]
 :description "A tool for managing secrets."
 :upstream_url "https://www.vaultproject.io/"
 :source {:url "https://releases.hashicorp.com/vault/1.1.0/vault_1.1.0_linux_amd64.zip"
          :sha256 :65d665ee7ba08fb41a7113a2ae3c1d5fd7e0b530b59644ed7dc8a01870b2d73f
          :filename :vault-1.1.0_linux_amd64.zip}
 :build_deps [:karate/unzip]
 :bin_dirs [:bin]
 :svc {:user :root :group :root}
 :exports {:port :listener.port}
 :exposes [:port]
 :unpack (fn [b]
           (b:run [:unzip
                   :vault-1.1.0_linux_amd64.zip
                   :-d
                   (.. b.name "-" b.version)] {:cwd b.cache}))
 :build (fn [_b]
          nil)
 :install (fn [b]
            (b:copy (b:join b.src :vault) (.. b.prefix :/bin/vault))
            (b:chmod (.. b.prefix :/bin/vault) :755))}
