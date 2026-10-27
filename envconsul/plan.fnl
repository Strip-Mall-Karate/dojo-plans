;; envconsul, ported from its plan.sh.
{:name :envconsul
 :origin :karate
 :version :0.7.3
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MPL-2.0]
 :description "Launch a subprocess with environment variables using data from @HashiCorp Consul and Vault."
 :upstream_url "https://github.com/hashicorp/envconsul"
 :source {:url "https://releases.hashicorp.com/envconsul/0.7.3/envconsul_0.7.3_linux_amd64.zip"
          :sha256 :67ed44cb254da24ca5156ada6d04e3cfeba248ca0c50a5ddd42282cbafde80bc
          :filename :envconsul-0.7.3_linux_amd64.zip}
 :build_deps [:karate/unzip]
 :bin_dirs [:bin]
 :unpack (fn [b]
           (b:run [:unzip
                   :envconsul-0.7.3_linux_amd64.zip
                   :-d
                   (.. b.name "-" b.version)] {:cwd b.cache}))
 :build (fn [b]
          nil)
 :install (fn [b]
            (b:copy b.name (.. b.prefix :/bin/ b.name))
            (b:chmod (.. b.prefix :/bin/ b.name) :755))}
