;; scaffolding-node, ported from its plan.sh: its package is lib/scaffolding.fnl.
;; The bash scaffolding read package.json with jq and default.toml with rq, and
;; asked Builder for Node versions with curl and bc; the Fennel module reads
;; them itself, so its package needs only what the app's build runs.
{:name "scaffolding-node"
 :origin "karate"
 :version "0.6.14"
 :targets ["x86_64-linux" "aarch64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "Dojo Plan Scaffolding for Node.js Applications"
 :upstream_url "https://github.com/StripMallKarateCompany/dojo-plans/tree/main/scaffolding-node"
 :deps ["karate/tar" "karate/coreutils"]
 :scaffolding "karate/scaffolding-base"}
