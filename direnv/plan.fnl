;; direnv, ported from its plan.sh.
{:name "direnv"
 :origin "karate"
 :version "2.19.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MIT"]
 :description "direnv is an environment switcher for the shell."
 :upstream_url "https://direnv.net/"
 :source {:url "https://github.com/direnv/direnv/releases/download/v2.19.1/direnv.linux-amd64" :sha256 "3341afc4a2255a680e446230f9db5cee66f2f208f3c43cb251ba908957fe7636" :filename "direnv.linux-amd64"}
 :bin_dirs ["bin"]
 :unpack (fn [b]
          nil)
 :build (fn [b]
          nil)
 :install (fn [b]
          (b:copy (.. b.cache "/direnv.linux-amd64") (.. b.prefix "/bin/" b.name))
          (b:chmod (.. b.prefix "/bin/" b.name) "0755"))
 :strip (fn [b]
          nil)}
