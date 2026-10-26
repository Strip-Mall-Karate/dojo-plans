;; packer, ported from its plan.sh.
{:name "packer"
 :origin "karate"
 :version "1.3.5"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MPL2"]
 :description "Packer is a tool for creating machine and container images for multiple platforms from a single source configuration."
 :upstream_url "https://packer.io"
 :source {:url "https://releases.hashicorp.com/packer/1.3.5/packer_1.3.5_linux_amd64.zip" :sha256 "14922d2bca532ad6ee8e936d5ad0788eba96f773bcdcde8c2dc7c95f830841ec"}
 :build_deps ["karate/unzip"]
 :bin_dirs ["bin"]
 :unpack (fn [b]
          (b:run ["unzip" "packer_1.3.5_linux_amd64.zip" "-d" (.. b.name "-" b.version)] {:cwd b.cache}))
 :build (fn [b]
          nil)
 :install (fn [b]
          (b:copy (b:join b.src "packer") (.. b.prefix "/bin/packer"))
          (b:chmod (.. b.prefix "/bin/packer") "755"))}
