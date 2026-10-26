;; runc, ported from its plan.sh.
{:name "runc"
 :origin "karate"
 :version "0.1.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "CLI tool for spawning and running containers according to the OCI specification"
 :upstream_url "https://www.opencontainers.org/"
 :source {:url "https://github.com/opencontainers/runc" :sha256 "73549dc3eb29005dae5248385c6b40310a323b817714853d35d7194abfa357b8"}
 :build_deps ["karate/pkg-config" "karate/libseccomp"]
 :scaffolding "karate/scaffolding-go"
 :bin_dirs ["bin"]}
