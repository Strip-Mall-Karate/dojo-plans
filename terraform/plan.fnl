;; terraform, ported from its plan.sh.
{:name "terraform"
 :origin "karate"
 :version "0.11.13"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MPL-2.0"]
 :description "Terraform is a tool for building, changing, and combining infrastructure safely and efficiently"
 :upstream_url "http://www.terraform.io/"
 :source {:url "https://releases.hashicorp.com/terraform/0.11.13/terraform_0.11.13_linux_amd64.zip" :sha256 "5925cd4d81e7d8f42a0054df2aafd66e2ab7408dbed2bd748f0022cfe592f8d2" :filename "terraform_0.11.13_linux_amd64.zip"}
 :build_deps ["karate/unzip"]
 :bin_dirs ["bin"]
 :unpack (fn [b]
          (b:run ["unzip" "terraform_0.11.13_linux_amd64.zip" "-d" (.. b.name "-" b.version)] {:cwd b.cache}))
 :build (fn [b]
          nil)
 :install (fn [b]
          (b:copy (b:join b.src "terraform") (.. b.prefix "/bin/terraform"))
          (b:chmod (.. b.prefix "/bin/terraform") "755"))}
