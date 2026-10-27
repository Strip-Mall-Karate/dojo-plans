;; bash-completion, ported from its plan.sh.
{:name :bash-completion
 :origin :karate
 :version :2.8
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-2.0]
 :description "Programmable completion functions for bash"
 :upstream_url "https://github.com/scop/bash-completion"
 :source {:url "https://github.com/scop/bash-completion/releases/download/2.8/bash-completion-2.8.tar.xz"
          :sha256 :c01f5570f5698a0dda8dc9cfb2a83744daa1ec54758373a6e349bd903375f54d}
 :deps [:karate/bash]
 :build_deps [:karate/gcc :karate/make]}
